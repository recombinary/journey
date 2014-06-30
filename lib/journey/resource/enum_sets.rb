require 'active_support/concern'

module Journey::Resource::EnumSets
  extend ActiveSupport::Concern

  included do
    def self.enum_set(attr, collection=[])
      (@enum_sets ||= []) << attr

      collection_const_name = attr.to_s.pluralize.upcase.to_sym
      const_set collection_const_name, collection.freeze

      define_method "#{attr}_values" do
        self.class.const_get(collection_const_name)
      end

      define_method attr do
        arr = attributes[attr.to_s].presence || []
        arr.map do |member|
          if member.is_a?(Fixnum)
            self.class.const_get(collection_const_name)[member]
          else
            member
          end
        end
      end

      define_method "#{attr}=" do |value|
        attributes[attr.to_s] = value.map do |member|
          if member.is_a?(Fixnum)
            member
          else
            self.class.const_get(collection_const_name).index(member)
          end
        end 
      end

      define_method "add_#{attr}" do |value|
        attr_values = send("#{attr}_values")

        value_index = if value.is_a?(Fixnum)
          value
        else
          attr_values.index(value)
        end

        if (0..attr_values.size-1).include? value_index
          (attributes[attr.to_s] ||= []) << value_index
        else
          raise "Invalid enum_set value: '#{value}' for '#{attr}'"
        end
      end
    end

  end

end
