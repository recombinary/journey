require 'spec_helper'

describe Journey::Resource do
  let(:klass) do 
    Class.new(Journey::Resource) do
      self.element_name = 'technician'
    end
  end

  describe '::Enums' do
    describe '.enum' do
      let(:statuses) { %w(Active Inactive) }
      before do
        klass.enum :status, statuses
      end

      it 'stores the collection' do
        expect(klass::STATUSES).to eq(statuses)
        expect(klass.new.status_values).to eq(statuses)
      end
      
      it 'gets and sets enumerated attributes' do
        r = klass.create(name: 'X', status: 'Inactive')
        expect(r).to be_persisted
        r.status = 'Active'
        r.save
        r.reload
        expect(r.status).to eq('Active')
      end

      it 'sets nil attribute when receiving a blank value' do
        r = klass.create(name: 'X', status: 'Inactive')
        expect(r).to be_persisted
        r.status = ''
        r.save
        r.reload
        expect(r.status).to be_nil
      end

      it 'gets and sets enumerated attributes as a hash' do
        r = klass.create(name: 'X', status: 'Inactive')
        expect(r).to be_persisted
        r.update_attributes(status: '')
        r.save
        r.reload
        expect(r.status).to be_nil        
      end
    end
  end

  describe '::Queries' do
    describe '.where' do

      it 'returns matching objects, sorted by attribute' do
        klass.all.each(&:destroy)

        klass.create(name: 'Z', status: 'Active')
        klass.create(name: 'M', status: 'Inactive')
        klass.create(name: 'A', status: 'Active')

        collection = klass.where(status: 'Active', sort: { name: :asc })
        expect(collection.map(&:name)).to eq %w[A Z]
      end 
    end
  end
end
