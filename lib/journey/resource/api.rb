require 'active_support/concern'

module Journey::Resource::API
  extend ActiveSupport::Concern
  
  included do
    self.format = :json
    self.include_root_in_json = true
    self.headers['accept-encoding'] = 'gzip'
  end
end
