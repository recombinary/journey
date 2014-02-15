module TestConfiguration
  def self.configure_for_test
    Journey.configure do |c|
      c.api_site = 'https://run-staging.journeyapps.com/api/v1'
      c.api_user = '52d3d94c1ea10fe365000557'
      c.api_password = 'MejFSJzOaMVThhIeTJtd'
    end
  end
end
