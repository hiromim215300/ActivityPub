context = true unless context == false
json.set! '@context', 'https://www.w3.org/ns/activitystreams' if context

json.id federation_actor_activity_url activity.actor, activity
json.type activity.action
json.actor activity.actor.federated_url
json.to ['https://www.w3.org/ns/activitystreams#Public']
json.object activity.entity.federated_url

