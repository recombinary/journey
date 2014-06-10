require 'active_support/concern'

module Journey::Resource::EnumSets
  extend ActiveSupport::Concern

  included do
    def self.enum_set(attr, collection=[])
      collection_const_name = attr.to_s.pluralize.upcase.to_sym
      const_set collection_const_name, collection.freeze      
      define_method "#{attr}_values" do
        self.class.const_get(collection_const_name)
      end
    end

  end

end
