require 'fediverse/inbox'
require 'uri'
require 'json'
require 'open-uri'
$time=[]

module Federation
  class ActivitiesController < FederationApplicationController
    before_action :set_federation_activity, only: [:show]

    def outbox
      @actor            = Actor.find(params[:actor_id])
      @activities       = policy_scope Activity.where(actor: @actor).order(created_at: :desc)
      @total_activities = @activities.count
      @activities       = @activities.page(params[:page])
    end

    def show; end

    def create
      start_time = Time.now
      puts("Create Test start_time=#{start_time}")
      payload = payload_from_params
      puts("payload =  #{payload}")
#      return  render json: {}, status: 422
#      render json: {}, status: 422 unless payload
#     render json: {}, status: :unprocessable_entity unless payload
      render json: {}, status: :unprocessable_entity unless payload
#      payload
      if Fediverse::Inbox.dispatch_request(payload)
        render json: {}, status: :created
        puts(":created")
        puts("処理速度=#{Time.now - start_time}s")
      else
        render json: {}, status: :unprocessable_entity
        puts(":unprocessable_entity")
      end
      end_time = Time.now - start_time
      $time.push(end_time)
      puts("処理速度=#{Time.now - start_time}s")
      puts($time)
    end

    private

    def set_federation_activity
      @activity = Activity.find_by!(actor_id: params[:actor_id].to_i, id: params[:id].to_i)
    end

    def activity_params
      params.fetch(:activity, {})
    end

    def payload_from_params
      payload_string = request.body.read
      request.body.rewind if request.body.respond_to? :rewind
      puts("確認用:payload_string = #{payload_string}")
#      puts("payload_string['to'] = #{payload_string['to']}")
#      puts("payload_string['to'].include?('http://192.168.2.106:3000/federation/actors/1/inbox')? : #{payload_string['to'].include?('http://192.168.2.106:3000/federation/actors/1/inbox')}")
      if payload_string['to'].include?('http://192.168.2.106:3000/federation/actors/1/inbox') == true
         puts("転送やります.")
         NotifyInbox.perform_later(payload_string)
      end         
      begin
         puts ("ここに来て欲しい！")
         payload = JSON.parse(payload_string)
         puts(payload)
      rescue JSON::ParserError
        return
      end
     # puts(payload)
      hash = JSON::LD::API.compact payload, payload['@context']
      validate_payload hash
      url = hash['object']
      to = hash['to']
      puts("to: #{to}")
      puts("hash['to'].include?('http://192.168.2.106:3000/federation/actors/1/inbox')? : #{hash['to'].include?('http://192.168.2.106:3000/federation/actors/1/inbox')}")
      if hash['to'].include?('http://192.168.2.106:3000/federation/actors/1/inbox') == true
 #        puts("転送やります.")
#         NotifyInboxJob.perform_later(hash)
      end
      p url
      json = JSON.parse( open(url).read )
      p json
    end

    def validate_payload(hash)
      puts("確認:hash = #{hash}") 
      return unless hash['@context'] && hash['id'] && hash['type'] && hash['actor'] && hash['object'] && hash['to']

      hash
    end
  end
end


