require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ActivityPub
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.assets.initialize_on_precompile = false
    #config.site = config_for(:site)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    config.site = config_for(:site)
    udp = UDPSocket.new
    # クラスBの先頭アドレス,echoポート 実際にはパケットは送信されない。
    udp.connect("128.0.0.0", 7)
    adrs = Socket.unpack_sockaddr_in(udp.getsockname)[1]
    udp.close
    config.action_mailer.default_url_options = { host: "https://#{adrs}", port: "3000" }
#    self.active_record.enumerate_columns_in_select_statements = true
    # -- all .rb files in that directory are automatically loaded.
  end
end

#module Co
#  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
#    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # Generate JS translations
#    config.middleware.use I18n::JS::Middleware
 #   config.site = config_for(:site)
  #  config.action_mailer.default_url_options = { host: "#{config.site.scheme}://#{config.site.host}", port: config.site.port }
  #  config.action_mailer.default_options = { from: config.site.emails_from }
 # end

#end
