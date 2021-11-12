module CookiesHelper
    def display_filling(input_string)
        input_string.to_s.strip.empty? ? "no filling" : input_string
    end
end