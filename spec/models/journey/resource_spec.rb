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

        klass.create(name: 'X', status: 'Active')
        klass.create(name: 'Z', status: 'Active')
        klass.create(name: 'M', status: 'Inactive')
        klass.create(name: 'A', status: 'Active')
        klass.create(name: 'B', status: 'Active')

        collection = klass.where(q: { status: 'Active' }, sort: { name: :asc }, skip: 1, limit: 2)
        expect(collection.map(&:name)).to eq %w[B X]
      end 
    end
  end


  describe '::Search' do
    it 'returns matching objects when matches are made' do
      uuid = SecureRandom.uuid

      matched_objects = [
        klass.create(name: "#{SecureRandom.uuid}#{uuid}"),
        klass.create(name: "#{SecureRandom.uuid}#{uuid}")
      ]
      expect(matched_objects.all?(&:persisted?)).to be true

      unmatched_objects = [
        klass.create(name: "#{SecureRandom.uuid}"),
        klass.create(name: "#{SecureRandom.uuid}")
      ]
      expect(unmatched_objects.all?(&:persisted?)).to be true

      searched_objects = klass.search(uuid)

      matched_objects.each do |object|
        expect(searched_objects).to include(object)
      end

      unmatched_objects.each do |object|
        expect(searched_objects).not_to include(object)
      end
    end

    it 'returns an empty array when no matches are made' do
      results = klass.search(SecureRandom.uuid)
      expect(results).to_not be_any
    end
  end
end
