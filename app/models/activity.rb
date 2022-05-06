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

  def object
    note = @current_user.note
    data = ApplicationController.renderer.new.render(
      template: 'federation/notes/show',
      locals: { :@note => note },
      format:   :json
    )
    puts("NOTE = #{data}")
  end

  def recipients # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
    return [] unless actor.local?

    actors = []
    case action
    when 'Create'
#      inbox_url = "https://192.168.2.105:3000/actors/1/"
      puts("actors.push")
#      actors.push('http://192.168.2.101:3000/actors/1')  if entity_type == 'Note'
#        str_name = "1"
#        str_host = "https://192.168.2.101:3000/actors/"
#        x = "/inbox"
#        tweet(str_name, str_host, x)
    end
    actors
  end

  private

  def post_to_inboxes
    NotifyInboxJob.perform_later(self)
  end
end
