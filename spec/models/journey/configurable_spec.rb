require 'spec_helper'

module Journey
  describe "configurable" do
    let(:api_site) { 'https://mysite.dev/' }

    describe '.configure' do
      it 'configures with a block' do
        expect(Journey.configuration.api_site).not_to equal api_site
        Journey.configure { |c| c.api_site = api_site }
        expect(Journey.configuration.api_site).to equal api_site
      end

      it 'configures with a hash' do
        expect(Journey.configuration.api_site).not_to equal api_site
        Journey.configure({ api_site: api_site })
        expect(Journey.configuration.api_site).to equal api_site
      end
    end

    describe '.configuration=' do
      it 'configures with a configuration object' do
        expect(Journey.configuration.api_site).not_to equal api_site

        configuration = Configuration.new(api_site: api_site)
        Journey.configuration=(configuration)

        expect(Journey.configuration.api_site).to equal api_site
      end
    end

    describe '.logger=' do
      it 'sets the logger for ActiveResource' do
        logger = Logger.new(STDOUT)
        Journey.logger = logger
        expect(ActiveResource::Base.logger).to equal logger
        expect(Journey.logger).to equal(logger)
      end
    end

    describe '.logger' do
      it 'returns a default logger if one isnt set' do
        expect(Journey.logger).to_not be_nil
        expect(Journey.logger).to respond_to(:info)
      end
    end
  end
end
