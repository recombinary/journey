require 'active_support/concern'

module Journey::Resource::WhereMultiple
  extend ActiveSupport::Concern

  included do
    def self.where_multiple(c)
      clauses = c.dup

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
        where(clauses.merge(query: query))
      end
    end

    def self.count_multiple(c)
      # TODO refactor me to re-use all the same recursive query logic in `where_multiple`
      clauses = c.dup

      query = clauses.delete(:query)
      query_keys_with_array_values = query.map do |key, value|
        key if value.is_a?(Array)
      end.compact

      if branch_key = query_keys_with_array_values.first
        consistent_query = query.except(branch_key)
        value_branches = query[branch_key]

        value_branches.map do |value|
          branch_query = consistent_query.merge(branch_key => value)
          count_multiple(clauses.merge(query: branch_query))
        end.sum

      else
        count(clauses.merge(query: query))
      end

    end
  end

end
