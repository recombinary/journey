# Journey

A ruby wrapper for the Journey API. http://resources.journeyapps.com/api

## Installation

Add this line to your application's Gemfile:

    gem 'embark-journey', require: 'journey'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install embark-journey

## Usage

Configure Journey to use the relevant API credentials. For Rails, this would be placed in an initializer.

    Journey.configure do |c|
      c.api_site = ENV['JOURNEY_API_ENDPOINT']
      c.api_user = ENV['JOURNEY_API_USERNAME']
      c.api_password = ENV['JOURNEY_API_KEY']
    end


Create your resource models, inheriting from `Journey::Resource`. Under the hood, resources extend `ActiveResource::Base`. 

    class User < Journey::Resource
      schema do
        string :name
        datetime :last_login
        string :state
      end

      enum :state, %w[Active Inactive]
    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
