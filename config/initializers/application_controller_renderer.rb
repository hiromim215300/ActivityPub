# Be sure to restart your server when you modify this file.

# ActiveSupport::Reloader.to_prepare do
#   ApplicationController.renderer.defaults.merge!(
#     http_host: 'example.org',
#     https: false
#   )
# end
ActiveSupport::Reloader.to_prepare do
  site_config = Rails.application.config.site
  ApplicationController.renderer.defaults.merge!(
#    http_host: site_config.port ? "#{site_config.host}:#{site_config.port}" : site_config.host,
#    https:     site_config.scheme == 'https'
  )
end

