module Journey
  class Resource < ActiveResource::Base

    def self.find(*arguments)
      scope   = arguments.slice!(0)

      options = arguments.slice!(0) || {}

      self.embeds ||= []

      unless options.has_key?(:embed) && !options.delete(:embed)
        options.deep_merge!(params: { embed: embeds })
      end

      super *([scope, options] + arguments)
    end

  end
end

require 'journey/resource/api'
require 'journey/resource/attribute_loading'
require 'journey/resource/enums'
require 'journey/resource/enum_sets'
require 'journey/resource/queries'
require 'journey/resource/search'
require 'journey/resource/embed'
require 'journey/resource/count'

class Journey::Resource
  include API
  include Queries
  include Enums
  include EnumSets
  include AttributeLoading
  include Search
  include Embed
  include Count
end


