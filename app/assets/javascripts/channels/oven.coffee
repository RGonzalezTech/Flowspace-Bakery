actions = {
  connected: () ->
    console.log("Connected!")
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log("Received: ", data)
    # Called when there's incoming data on the websocket for this channel
}
$(document).on('turbolinks:load', () ->
  if $('body').hasClass('oven') && !App.oven
    App.oven = App.cable.subscriptions.create({ channel: "OvenChannel", oven_id: 1}, actions)
  else
    if App.oven
      App.oven.unsubscribe()
      App.oven = undefined
)