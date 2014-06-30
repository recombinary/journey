require 'active_support/concern'

module Journey::Resource::AttributeLoading
  extend ActiveSupport::Concern

  included do
    def load(attributes, remove_root = false, persisted = false)
      # 'data' is a reserved key in ActiveResource,
      # but Journey uses it for the Oplog
      attributes['content'] = attributes.delete('data')

      super(attributes, remove_root, persisted).tap do

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
