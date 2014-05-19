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

  describe '::Embed' do
    class Asset < Journey::Resource
    end

    class Fault < Journey::Resource
    end

    class Job < Journey::Resource
      belongs_to :asset, embed: true
      belongs_to :reported_fault, class_name: 'Fault', embed: true
    end

    it 'loads an embedded belongs_to association automatically' do
      asset = Asset.create name: 'asset'
      fault = Fault.create name: 'fault'

      job = Job.create name: 'job', asset_id: asset.id, reported_fault_id: fault.id
      id = job.id
      job = Job.find(id)

      expect(job.attributes['asset']).to eq asset
      expect(job.asset).to eq asset

      expect(job.attributes['reported_fault']).to eq fault
      expect(job.reported_fault).to eq fault
    end

    it 'skips embedded belongs_to associations when opted for' do
      asset = Asset.create name: 'asset'
      fault = Fault.create name: 'fault'

      job = Job.create name: 'job', asset_id: asset.id, reported_fault_id: fault.id
      id = job.id
      job = Job.find(id, embed: false)

      expect(job.attributes['asset']).to be_nil
      expect(job.asset).to eq asset

      expect(job.attributes['reported_fault']).to be_nil
      expect(job.reported_fault).to eq fault
    end


  end


  describe '::Count' do
    it 'returns a count of objects when some are matched' do
      uuid = SecureRandom.uuid

      matched_objects = [
        klass.create(name: uuid),
        klass.create(name: uuid)
      ]
      expect(matched_objects.all?(&:persisted?)).to be true

      count = klass.count(query: { name: uuid })
      expect(count).to eq(matched_objects.count)
    end

    it 'returns 0 for no matching objects' do
      count = klass.count(query: { name: SecureRandom.uuid })
      expect(count).to eq(0)
    end
  end
end
