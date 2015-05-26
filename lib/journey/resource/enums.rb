require 'active_support/concern'

module Journey::Resource::Enums
  extend ActiveSupport::Concern

  included do
    def self.enum(attr, collection=[])
      collection_const_name = attr.to_s.pluralize.upcase.to_sym
      const_set collection_const_name, collection.freeze      
      define_method "#{attr}_values" do
        self.class.const_get(collection_const_name)
      end

      instance_eval do
        # TODO deprecated?
        attr_accessor :"#{attr}_index"
      end

      define_method attr do

        value = attributes[attr.to_s].presence

        real_value = if value.is_a?(Fixnum)
          send("#{attr}_values")[value]
        else
          value
        end

        if real_value && real_value.respond_to?(:inquiry)
          real_value.inquiry
        else
          real_value
        end
      end

      define_method "#{attr}=" do |value|
        attributes[attr.to_s] = value.presence
      end
    end

  end

end
