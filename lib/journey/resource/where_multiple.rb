require 'active_support/concern'

module Journey::Resource::WhereMultiple
  extend ActiveSupport::Concern

  included do
    def self.where_multiple(clauses)

      query = clauses.delete(:query)
      query_keys_with_array_values = query.map do |key, value|
        key if value.is_a?(Array)
      end.compact

      if branch_key = query_keys_with_array_values.first
        consistent_query = query.except(branch_key)
        value_branches = query[branch_key]

        value_branches.map do |value|
          branch_query = consistent_query.merge(branch_key => value)
          where_multiple(clauses.merge(query: branch_query))
        end.map(&:to_a).sum

      else
        where(clauses)
      end
    end
  end

end
