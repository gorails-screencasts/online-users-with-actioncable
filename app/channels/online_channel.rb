class OnlineChannel < ApplicationCable::Channel
  def subscribed
    # Save online status
    ActionCable.server.pubsub.redis_connection_for_subscriptions.sadd "online", current_user.id

    stream_from "online:users"

    html = ApplicationController.render(partial: "users/online", locals: { user: current_user })
    broadcast_to "users", { id: current_user.id, status: "online", html: html }
  end

  def unsubscribed
    # Remove online status
    ActionCable.server.pubsub.redis_connection_for_subscriptions.srem "online", current_user.id

    broadcast_to "users", { id: current_user.id, status: "offline" }
  end
end
