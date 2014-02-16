require 'spec_helper'

module Journey
  class PrefixedResource < Resource
    self.prefix = '/admin/'
  end

  describe Configuration do 
    let(:configuration) { Configuration.new }

    it 'has nil defaults' do
      expect(configuration.api_site).to be_nil
      expect(configuration.api_user).to be_nil
      expect(configuration.api_password).to be_nil
    end

    describe '#propagate!' do
      it 'updates all descended records' do
        configuration.api_site = 'https://custom.journeyapps.com/api/v1' 
        configuration.api_user = 'dan'
        configuration.api_password = 'mellon'

        [Resource, PrefixedResource].each do |klass|
          expect(klass.site.to_s).not_to eq configuration.api_site
          expect(klass.user).not_to eq configuration.api_user
          expect(klass.password).not_to eq configuration.api_password
        end
        
        configuration.propagate!

        [Resource, PrefixedResource].each do |klass|
          expect(klass.site.to_s).to eq configuration.api_site
          expect(klass.user).to eq configuration.api_user
          expect(klass.password).to eq configuration.api_password
        end
      end
    end
  end
end
