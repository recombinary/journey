require 'pry'
require 'journey'


require 'dotenv'
Dotenv.load

require 'factory_girl'

Dir["spec/support/**/*.rb"].each { |f| require "./#{f}" }

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.order = 'random'
    
  config.before(:suite){ TestConfiguration.configure_for_test }
  
  config.before(:each){ ConfigurationCache.pull }
  config.after(:each){ ConfigurationCache.push }

end
