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

    def self.where(clauses={})
      raise ArgumentError, "expected a clauses Hash, got #{clauses.inspect}" unless clauses.is_a? Hash
      embed = clauses.delete(:embed)
      arguments = { params: clauses }
      arguments.merge!(embed: embed) if embed
      find(:all, arguments)
    end

  end
end

require 'journey/resource/api'
require 'journey/resource/attachments'
require 'journey/resource/attribute_loading'
require 'journey/resource/count'
require 'journey/resource/embed'
require 'journey/resource/enums'
require 'journey/resource/enum_sets'
require 'journey/resource/queries'
require 'journey/resource/search'

class Journey::Resource
  include API
  include Attachments
  include AttributeLoading
  include Count
  include Embed
  include Enums
  include EnumSets
  include Queries
  include Search
end


