module TestConfiguration
  def self.configure_for_test
    Journey.configure do |c|
      c.api_site = ENV['JOURNEY_API_ENDPOINT']
      c.api_user = ENV['JOURNEY_API_USERNAME']
      c.api_password = ENV['JOURNEY_API_KEY']
    end
    binding.pry
  end
end
