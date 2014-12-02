require 'active_support/concern'

module Journey::Resource::Attachments
  extend ActiveSupport::Concern

  included do
    def self.attachment(attr)
      define_method "#{attr}_path" do |size='original'|
        if respond_to?(:display_attachments)
          if display_attachments.respond_to?(attr) && paths = display_attachments.send(attr)
            paths.send(size)
          end
        end
      end

      define_method "#{attr}_url" do |size='original'|
        uri = URI.parse(Journey.configuration.api_site)
        if path = send("#{attr}_path", size)
          path, query = *path.split("?")
          uri.path = path
          uri.query = query
          return uri.to_s
        end
      end
    end
  end

end