require 'active_support/concern'

module Journey::Resource::Search
  extend ActiveSupport::Concern

  included do
    def self.search(q) # TODO add opts here
      instantiate_collection format.decode(post(:search, q: q).body)
    end
  end

end
