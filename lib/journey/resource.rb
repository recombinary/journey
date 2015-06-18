module Journey
  class Resource < ActiveResource::Base

    def self.find(*arguments)
      scope   = arguments.slice!(0)

      options = arguments.slice!(0) || {}

      self.embeds ||= []

      if options.has_key?(:embed)
        embed_option = options.delete(:embed)
        options.deep_merge!(params: { embed: embed_option }) if embed_option
      else
        options.deep_merge!(params: { embed: embeds })
      end

      super *([scope, options] + arguments)
    end

    def self.where(clauses={})
      raise ArgumentError, "expected a clauses Hash, got #{clauses.inspect}" unless clauses.is_a? Hash

      arguments = if clauses.has_key?(:embed)
        embed = clauses.delete(:embed)
        { params: clauses, embed: embed }        
      else
        { params: clauses }
      end

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
require 'journey/resource/where_multiple'

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
  include WhereMultiple
end


