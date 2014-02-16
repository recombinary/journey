require 'active_resource/active_resource'
module Journey
  class Resource < ActiveResource::Base
  end
end

require 'journey/resource/api'
require 'journey/resource/attribute_loading'
require 'journey/resource/enums'
require 'journey/resource/queries'

class Journey::Resource
  include API
  include Queries
  include Enums
  include AttributeLoading
end


