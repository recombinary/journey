require 'active_support/concern'

module Journey::Resource::Count
  extend ActiveSupport::Concern

  included do
    def self.count(constraints)
      get(:count, constraints)["count"]
    end
  end

end
