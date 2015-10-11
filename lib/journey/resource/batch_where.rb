require 'active_support/concern'

module Journey::Resource::BatchWhere
  extend ActiveSupport::Concern

  included do

    def self.batch_where(clauses, batch_size=100)

      total_count = count_multiple(clauses)
      query_count = (total_count / batch_size.to_f).ceil.to_i

      (0 ... query_count).to_a.map do |batch_index|

        where_multiple clauses.merge({
          limit: batch_size,
          skip: batch_index * batch_size
        })

      end.flatten
    end

  end
end
