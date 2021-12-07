module Routeable
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
  end

  def default_url_options
    udp = UDPSocket.new
    # クラスBの先頭アドレス,echoポート 実際にはパケットは送信されない。
    udp.connect("128.0.0.0", 7)
    adrs = Socket.unpack_sockaddr_in(udp.getsockname)[1]
    udp.close
    { host: "#{adrs}", port: "3000" }
  end
end

