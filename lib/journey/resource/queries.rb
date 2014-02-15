require 'active_support/concern'

module Journey::Resource::Queries
  extend ActiveSupport::Concern

  included do
    def self.where(clauses = {})
      sort = clauses.delete(:sort)
      params = { q: clauses }
      params[:sort] = sort if sort
      super(params)
    end
  end
end
