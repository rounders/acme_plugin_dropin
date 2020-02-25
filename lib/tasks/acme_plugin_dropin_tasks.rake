desc "acme_plugin"
task :acme_plugin => :environment do
  AcmePluginDropin.generate_cert
end
