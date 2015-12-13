require 'active_support/concern'

module Journey::Resource::AttributeLoading
  extend ActiveSupport::Concern

  included do
    def load(attributes, remove_root = false, persisted = false)
      # 'data' is a reserved key in ActiveResource,
      # but Journey uses it for the Oplog
      if content = attributes.delete('data')
        attributes['content'] = content
      end

      super(attributes, remove_root, persisted).tap do

        # set the cached value of any updated associations (e.g. parent_id)
        # to nil so that they can be re-fetched
        attributes.keys.map(&:to_s).select{ |key| key =~ /_id$/ }.each do |association_key|
          association = association_key.gsub /_id$/, ''
          instance_variable_set("@#{association}", nil)
        end

        # allow enum_sets to be loaded by key (rather than index)
        # by auto-converting them on initialization
        if enum_sets = self.class.instance_variable_get(:@enum_sets)
          enum_sets.each do |enum_attr|
            send("#{enum_attr}=", send(enum_attr))
          end
        end
      end
    end
  end

end
