require 'json'
require 'openssl'
require 'time'
require 'uri'
require 'net/http'
require 'utils/host'
require 'fediverse/webfinger'

class Note < ApplicationRecord
  include Routeable

  validates :content, presence: true
  belongs_to :actor
  
  before_create :federated_url

  has_many :activities, as: :entity, dependent: :destroy

  after_create :create_activity
#  after_create :post_to_inboxes
#  after_create :apipost

#  def recipients # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
#    return [] unless actor.local?#

#    actors = []
#    case action
#    when 'Create'
#      inbox_url = "https://192.168.2.105:3000/actors/1/"
#      puts("actors.push")
#      actors.push('http://192.168.2.104:3000/actors/1')  if entity_type == 'Note'
#        str_name = "1"
#        str_host = "https://192.168.2.101:3000/actors/"
#        x = "/inbox"
#        tweet(str_name, str_host, x)
#    end
#    actors
#  end

  def federated_url
#    attributes['federated_url'].presence || federation_actor_note_url(actor_id: actor_id, id: id)
    #url = local? ? federation_actor_url(self) : attributes['federated_url'].presence
    first = Utils::Host.localhost
    second = self.actor_id
    self.federated_url = "http://#{first}:3000/federation/actors/#{second}/notes/5.json"
  end

  private
  
  def create_activity
    puts("Create Activity Test")
    puts("self=#{self}")
    Activity.create! actor: actor, action: 'Create', entity: self
  end   

  def apipost

    uri = URI.parse("https://192.168.2.101:3000/acrors/1/inbox")
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.path)
#    data = ApplicationController.renderer.new.render(
#      template: 'federation/notes/show',
#      locals: { :@note => note },
#      format:   :json
#    )
#    puts(data)
#    apipost(data)
#    req.set_form_data(data)

#    res = http.request(req)

  end

  def post_to_inboxes
    NotifyInboxJob.perform_later(self)
  end
end
