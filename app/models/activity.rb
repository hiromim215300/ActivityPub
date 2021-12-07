class Activity < ApplicationRecord
  belongs_to :entity, polymorphic: true
  belongs_to :actor

  scope :feed_for, lambda { |actor|
    actor_ids = []
    #Following.accepted.where(actor: actor).find_each do |following|
     # actor_ids << following.target_actor_id
    #end
    where(actor_id: actor_ids)
  }

  after_create_commit :post_to_inboxes
#  after_create_commit :post_activity
#  def get_inbox(req)
#    puts req
#    res = HTTP[accept: 'application/activity+json'].get(req)
#    JSON.parse(res)
#
#  end

  def post_inbox(req, res, headers)
    puts req, res
    HTTP[headers].post(req, json: res)
  end

  def post_activity
    uri = URI.parse("https://192.168.2.101:3000/acrors/1/inbox")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(uri.path)
    data = ApplicationController.renderer.new.render(
      template: 'federation/activities/show',
      locals: { :@activity => activity },
      format:   :json
    )
    puts(data)
#    apipost(data)
    req.set_form_data(data)
    res = http.request(req)
  end

  def recipients # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
    return [] unless actor.local?

    actors = []
    case action
    when 'Create'
#      inbox_url = "https://192.168.2.105:3000/actors/1/"
#      actors.push('192.168.2.102:3000/actors/1')  if entity_type == 'Note'
#        str_name = "1"
#        str_host = "https://192.168.2.101:3000/actors/"
#        x = "/inbox"
#        tweet(str_name, str_host, x)
#      end
    end
    actors
  end

  private

  def post_to_inboxes
    NotifyInboxJob.perform_later(self)
  end
end
