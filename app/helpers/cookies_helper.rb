module CookiesHelper
    def self.create_cookie_with(filling, storage)
        FactoryGirl.create(:cookie, fillings: filling, storage: storage)
    end
end