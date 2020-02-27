module AcmePluginDropin
  class Config
    def self.load_config(filename = Rails.root.join('config', 'acme_plugin.yml'))
      contents = File.read(filename)
      config_hash = YAML.load(ERB.new(contents).result)

      config = ActiveSupport::HashWithIndifferentAccess.new(config_hash.fetch(Rails.env))
      config[:output_cert_dir].sub!(/\A\//,'')
      config[:challenge_dir_name].sub!(/\A\//,'')

      config
    end
  end
end
