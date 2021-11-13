class OvenChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    oven_channel = "oven_#{params[:oven_id]}"
    stream_from oven_channel
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
