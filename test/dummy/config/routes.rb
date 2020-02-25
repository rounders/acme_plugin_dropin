Rails.application.routes.draw do
  mount AcmePluginDropin::Engine => "/acme_plugin_dropin"
end
