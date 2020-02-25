AcmePluginDropin::Engine.routes.draw do
  get '.well-known/acme-challenge/:challenge' => 'challenge#index'
end
