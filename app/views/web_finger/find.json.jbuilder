json.subject params[:resource]
# json.aliases [
#                  "https://mastodon.social/@Gargron",
#                  "https://mastodon.social/users/Gargron",
#              ]
json.links [
  {
    rel:  'http://webfinger.net/rel/profile-page',
    type: 'text/html',
    href: user_url(@user),
  },
  {
    rel:  'self',
    type: 'application/activity+json',
    href: @user.actor.federated_url,
  },
  # {
  #   rel:      'http://ostatus.org/schema/1.0/subscribe',
  #   template: "#{interactions_url}?uri={uri}",
  # },
]

