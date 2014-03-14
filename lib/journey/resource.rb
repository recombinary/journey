module Journey
  class Resource < ActiveResource::Base

    def self.find(*arguments)
      scope   = arguments.slice!(0)

      self.embeds ||= []
      options = arguments.slice!(0) || {}
      options.deep_merge!(params: { embed: self.embeds })

      super *([scope, options] + arguments)
    end

  end
end

require 'journey/resource/api'
require 'journey/resource/attribute_loading'
require 'journey/resource/enums'
require 'journey/resource/queries'
require 'journey/resource/search'
require 'journey/resource/embed'

class Journey::Resource
  include API
  include Queries
  include Enums
  include AttributeLoading
  include Search
  include Embed
end


