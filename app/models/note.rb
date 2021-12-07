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

  has_many :activities, as: :entity, dependent: :destroy

  after_create :create_activity
  after_create :apipost

  def federated_url
#    attributes['federated_url'].presence || federation_actor_note_url(actor_id: actor_id, id: id)
    #url = local? ? federation_actor_url(self) : attributes['federated_url'].presence
    first = Utils::Host.localhost
    second = self.actor_id
    self.federated_url = "https://#{first}:3000/actors/#{second}"
  end

  private
  
  def create_activity
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
end
