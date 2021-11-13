require 'rails_helper'
# set type to :feature so we can leverage session helpers
RSpec.describe BakerWorker, type: :feature do
  before(:each) do
    @user = create_and_signin
    @oven = @user.ovens.first
  end

  it "prepares cookies" do
    @oven.create_cookie!(fillings: "Chocolate")
    new_cookie = @oven.cookie
    expect(new_cookie.ready?).to be false

    # Execute immediately
    BakerWorker.new.perform(@oven.id)

    new_cookie.reload
    expect(new_cookie.ready?).to be true
  end
end
