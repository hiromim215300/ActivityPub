require 'fediverse/webfinger'

class WebFingerController < ApplicationController
  def find
    @user = User.find_by! username: username
    render formats: [:json]
  end

  def host_meta
    render content_type: 'application/xrd+xml', formats: [:xml]
  end

  def node_info
    render formats: [:json]
  end

  # FIXME: Move this action in another controller; it does not belong to webfinger
  def show_node_info
    render formats: [:json]
  end

  private

  def username
    account = Fediverse::Webfinger.split_resource_account params.require(:resource)
    # Fail early if user don't _seems_ local
    raise ActiveRecord::RecordNotFound unless account && Fediverse::Webfinger.local_user?(account)

    account[:username]
  end
end
