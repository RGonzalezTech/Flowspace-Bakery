class BakerWorker
  include Sidekiq::Worker

  def perform(oven_id)
    this_oven = Oven.find(oven_id)

    if this_oven.cookie
      this_oven.cookie.set_ready(true)
    end
  end
end
