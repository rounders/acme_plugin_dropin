# AcmePluginDropin

This is a dropin replacement for the "acme_plugin" gem. The "acme_plugin" gem uses the v1 endpoint for Lets Encrypt which is being deprecated in June.

## Usage


## Installation

remove the "acme_plugin" from your Gemfile and replace with:


```ruby
gem 'acme_plugin_dropin', git: 'https://github.com/rounders/acme_plugin_dropin.git'
```

update your routes file as follows:

replace

```ruby
mount AcmePlugin::Engine, at: '/'
```

with

```ruby
mount AcmePluginDropin::Engine, at: '/'
```

update your config/acme_plugin.yml file as follows:

replace any instances of:

```
endpoint: 'https://acme-v01.api.letsencrypt.org/'
```

with:

```
directory: 'https://acme-v02.api.letsencrypt.org/directory'
```

and any instances of:

```
endpoint: https://acme-staging.api.letsencrypt.org
```

with:

```
directory: 'https://acme-staging-v02.api.letsencrypt.org/directory'
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
