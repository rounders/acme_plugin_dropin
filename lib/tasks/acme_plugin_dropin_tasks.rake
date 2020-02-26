desc "acme_plugin"
task :acme_plugin => :environment do
  AcmePluginDropin::GeneratesCertificates.call
end
