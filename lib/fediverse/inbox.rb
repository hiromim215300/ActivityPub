require 'fediverse/request'

module Fediverse
  class Inbox
    class << self
      def dispatch_request(payload)
        puts("ここでのpayload_typeは#{payload['type']}")
        case payload['type']
        when 'Note'
          puts ("Begin Create 1")
          handle_create_request payload
#        when 'Create'
#          handle_create_request payload
        when 'Accept'
          handle_accept_request payload
        when 'Undo'
          handle_undo_request payload
        else
          # FIXME: Fails silently
          # raise NotImplementedError
        #  Rails.logger.debug "Unhandled activity type: #{payload['type']}"
          puts("Begin Create 2")
          handle_create_request payload
        end
      end

      private

      def handle_create_request(payload)
#        activity = Request.get(payload['object'])
        case payload['type']
        when 'Follow'
          handle_create_follow_request payload
        when 'Note'
          handle_create_note payload
        end
      end

      def handle_create_follow_request(activity)
        actor        = Actor.find_or_create_by_object activity['actor']
        target_actor = Actor.find_or_create_by_object activity['object']

        Following.create! actor: actor, target_actor: target_actor, federated_url: activity['id']
      end

      def handle_create_note(payload)
        puts("handle_create_note")
        actor = Actor.find_or_create_by_object payload['attributedTo']
        Note.create! actor: actor, content: payload['content'], federated_url: payload['id']
      end

      def handle_accept_request(payload)
        activity = Request.get(payload['object'])
        raise "Can't accept things that are not Follow" unless activity['type'] == 'Follow'

        actor        = Actor.find_or_create_by_object activity['actor']
        target_actor = Actor.find_or_create_by_object activity['object']
        raise 'Follow not accepted by target actor but by someone else' if payload['actor'] != target_actor.federated_url

        follow = Following.find_by actor: actor, target_actor: target_actor
        follow.accept!
      end

      def handle_undo_request(payload)
        activity = Request.get(payload['object'])
        raise "Can't undo things that are not Follow" unless activity['type'] == 'Follow'

        actor        = Actor.find_or_create_by_object activity['actor']
        target_actor = Actor.find_or_create_by_object activity['object']

        follow = Following.find_by actor: actor, target_actor: target_actor
        follow&.destroy
      end
    end
  end
end

