require 'active_attr'
require 'journey/resource'

module Journey
  class Configuration
    include ActiveAttr::Attributes
    include ActiveAttr::MassAssignment
    
    attribute :api_site
    attribute :api_user
    attribute :api_password

    def propagate!
      (Resource.descendants << Resource).each do |r|
        r.site = api_site
        r.user = api_user
        r.password = api_password
      end
    end
  end
end
