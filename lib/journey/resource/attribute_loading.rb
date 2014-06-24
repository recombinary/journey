require 'active_support/concern'

module Journey::Resource::AttributeLoading
  extend ActiveSupport::Concern

  included do
    def load(attributes, remove_root = false, persisted = false)
      # 'data' is a reserved key in ActiveResource,
      # but Journey uses it for the Oplog

      attributes['content'] = attributes.delete('data')
      super(attributes, remove_root, persisted)
    end
  end

end
