module AcmePluginDropin
  class GenerateCert
      def self.load_config(filename = Rails.root.join('config', 'acme_plugin.yml'))
    contents = File.read(filename)
    config_hash = YAML.load(ERB.new(contents).result)

    ActiveSupport::HashWithIndifferentAccess.new(config_hash.fetch(Rails.env))
  end

  def self.current_challenge
    options = load_config
    challenge_dir = options[:challenge_dir_name]
    response = IO.read(File.join(Rails.root, challenge_dir, 'challenge'))
  end

  def self.generate_cert
    new.generate_cert
  end

  attr_reader :options, :domains

  def initialize
    @options = self.class.load_config

    @domains = options[:domain].split(' ')
    options[:output_cert_dir].sub!(/\A\//,'')
    options[:challenge_dir_name].sub!(/\A\//,'')
  end

  def generate_cert
    order = client.new_order(identifiers: domains)

    order.authorizations.each do |authorization|
      challenge = authorization.http
      store_challenge(challenge)

      challenge.request_validation

      counter = 0
      while challenge.status == 'pending' && counter < 10
        sleep(1)
        counter += 1
      end
      raise "couldn't verify" unless challenge.status == 'valid'

      puts "Validated #{authorization.domain}"
    end


    csr = Acme::Client::CertificateRequest.new(names: domains)

    order.finalize(csr: csr)

    while order.status == 'processing'
      sleep(1)
      order.reload
    end

    store_certs(csr.private_key.to_pem, order.certificate)

    true
  end

  def store_certs(key, cert)
    cert_dir = Rails.root.join(options[:output_cert_dir])
    key_file = File.join(cert_dir, "#{options[:cert_name]}-key.pem")
    cert_file = File.join(cert_dir, "#{options[:cert_name]}-fullchain.pem")

    Dir.mkdir(cert_dir) unless File.directory?(cert_dir)

    puts "writing #{key_file}"
    File.open(key_file, 'w') {|f| f.write(key) }

    puts "writing #{cert_file}"
    File.open(cert_file, 'w') {|f| f.write(cert) }
  end

  def store_challenge(challenge)
    challenge_dir = File.join(Rails.root, options[:challenge_dir_name])
    Dir.mkdir(challenge_dir) unless File.directory?(challenge_dir)

    File.open(File.join(challenge_dir, 'challenge'), 'w') { |file| file.write(challenge.file_content) }
  end

  def private_key
    @private_key ||= OpenSSL::PKey::RSA.new(File.read(options.fetch(:private_key, nil)))
  end

  def client
    @client ||= Acme::Client.new(private_key: private_key, directory: options[:directory])
  end

  def register
    client.new_account(contact: "mailto:#{options[:email]}", terms_of_service_agreed: true)
  end
  end
end
