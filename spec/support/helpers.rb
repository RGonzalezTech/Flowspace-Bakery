require 'support/helpers/session_helpers'
require 'support/helpers/cookies_factory_helpers'
RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include CookiesFactoryHelpers, type: :feature
end