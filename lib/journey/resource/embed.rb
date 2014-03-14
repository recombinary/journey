require 'active_support/concern'

module Journey::Resource::Embed
  extend ActiveSupport::Concern

  included do
    # def self.search(q)
    #   instantiate_collection format.decode(post(:search, q: q).body)
    # end
  end

end
