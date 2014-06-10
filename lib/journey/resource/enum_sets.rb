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

      define_method attr do
        value = attributes[attr.to_s].presence
        value.presence || []
      end

      define_method "add_#{attr}" do |value|
        new_value = value.presence
        if send("#{attr}_values").include? new_value
          (attributes[attr.to_s] ||= []) << new_value
        else
          raise "Invalid enum '#{new_value}' for '#{attr}'"
        end
      end
    end

  end

end
