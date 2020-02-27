module AcmePluginDropin
  class GeneratesCertificates
    def self.call
      new.call
    end

    attr_reader :options, :domains

    def initialize(options = Config.load_config)
      @options = options

      @domains = options[:domain].split(' ')
    end

    def call
      order = client.new_order(identifiers: domains)

      order.authorizations.each do |authorization|
        puts "validating #{authorization.identifier["value"]}"

        challenge = authorization.http
        Challenge.store_challenge(challenge.file_content, options)

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
