require 'active_support/concern'

module Journey::Resource::API
  extend ActiveSupport::Concern
  
  included do
    self.format = :json
    self.include_root_in_json = true
    # self.site = ENV['JOURNEY_API_ENDPOINT']
    # self.user = ENV['JOURNEY_API_USERNAME']
    # self.password = ENV['JOURNEY_API_KEY']
  end
end
