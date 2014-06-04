require 'active_support/concern'

module Journey::Resource::AttributeLoading
  extend ActiveSupport::Concern

  included do
    # uses defined setters in place of attributes[key] where possible,
    # for the purpose of enums
    def load(attributes, remove_root = false, persisted = false)
      super(attributes, remove_root, persisted).tap do |x|
        # send each ENUM
        # self.attributes.each do |key, value|
        #   send("#{key}=", value) if respond_to?("#{key}=")
        # end
      end
    end
  end

end
