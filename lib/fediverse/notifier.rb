module Fediverse
  class Notifier
    class << self
      def post_to_inboxes(activity)
        actors = activity.recipients

        Rails.logger.debug 'Nobody to notice' && return if actors.count.zero?

        message = ApplicationController.renderer.new.render(
          template: 'federation/activities/show',
          locals:   { :@activity => activity },
          format:   :json
        )
        puts("Test")
        Faraday.post "http://192.168.2.106:3000/federation/actors/1/inbox", message, 'Content-Type' => 'application/json', 'Accept' => 'application/json'
        actors.each do |actor|
          actor.inbox_url = 'http://192.168.2.106:3000/federation/actors/1/inbox'
          Rails.logger.debug "Sending activity ##{activity.id} to #{actor.inbox_url}"
          Faraday.post actor.inbox_url, message, 'Content-Type' => 'application/json', 'Accept' => 'application/json'
          uri = URI.parse("http://192.168.2.106:3000/federation/actors/1/inbox")
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = false
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req = Net::HTTP::Post.new(uri.path)
      #    req.set_form_data({'id' => 'http://192.168.2.101:3000/actors/1/inbox'})
          res = http.request(req)         
        end
      end
    end
  end
end

