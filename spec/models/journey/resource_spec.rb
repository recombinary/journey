require 'spec_helper'

describe Journey::Resource do
  let(:klass) do 
    Class.new(Journey::Resource) do
      self.element_name = 'technician'
    end
  end

  context 'gzip performance patch' do
    it 'automatically enables gzip' do
      expect(klass.headers['accept-encoding']).to eq 'gzip'
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

      it 'remembers enum values' do
        r = klass.create(name: 'X', status: 'Inactive')
        expect(r).to be_persisted
        r = klass.find(r.id)
        expect(r.status).to eq 'Inactive'
      end

    end
  end


  describe '::EnumSets' do
    let(:klass) do 
      Class.new(Journey::Resource) do
        self.element_name = 'fault'
      end
    end

    describe '.enum_set' do
      let(:asset_types) { %w[ABM ATM] }

      before do
        klass.enum_set :asset_type, asset_types
      end

      it 'stores the collection' do
        expect(klass::ASSET_TYPES).to eq(asset_types)
        expect(klass.new.asset_type_values).to eq(asset_types)
      end
      
      it 'gets and sets enumerated attributes' do
        r = klass.create(name: 'X')
        expect(r).to be_persisted
        r.asset_type = ['ATM']
        expect(r.save).to be true

        r = klass.find(r.id)
        expect(r.asset_type).to eq ['ATM']
      end

      it 'remembers enum_set values' do
        r = klass.create(name: 'X', asset_type: ['ABM', 'ATM'])
        r = klass.find(r.id)
        expect(r.asset_type).to eq ['ABM', 'ATM']
      end

      it 'defaults to empty array' do
        r = klass.create(name: 'X', asset_type: nil)
        r = klass.find(r.id)
        expect(r.asset_type).to eq []
      end

      it 'converts integer indices to corresponding keys' do
        r = klass.create(name: 'X', asset_type: [0])
        expect(r.asset_type).to eq [klass::ASSET_TYPES.first]
      end

      it 'safely adds members' do
        r = klass.create(name: 'X', asset_type: nil)
        r = klass.find(r.id)
        r.add_asset_type 'ATM'
        expect(r.asset_type).to eq ['ATM'] 
        r.add_asset_type 'ABM'
        expect(r.asset_type).to eq ['ATM', 'ABM'] 
      end

      it 'raises an error when trying to add unrecognized values' do
        r = klass.create(name: 'X', asset_type: nil)
        r = klass.find(r.id)
        expect{ r.add_asset_type 'AXM' }.to raise_error
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

    it 'skips embedded belongs_to associations on Class.find when opted for' do
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

    it 'skips embedded belongs_to association on Class.where when opted for' do
      asset = Asset.create name: 'asset'
      fault = Fault.create name: 'fault'

      job_resolution_comments = SecureRandom.uuid
      job = Job.create name: 'job', resolution_comments: job_resolution_comments, asset_id: asset.id, reported_fault_id: fault.id

      job = Job.where(query: { resolution_comments: job_resolution_comments }, embed: false).first
      expect(job).to be_a Job

      expect(job.attributes['asset']).to be_nil
      expect(job.asset).to eq asset

      expect(job.attributes['reported_fault']).to be_nil
      expect(job.reported_fault).to eq fault
    end

    it 'updates an embedded association id correctly' do
      asset = Asset.create name: 'asset'
      job = Job.create name: 'job', asset_id: asset.id
      job = Job.find(job.id)

      new_asset = Asset.create name: 'asset'
      job.update_attributes(asset_id: new_asset.id)

      expect(Job.find(job.id).asset_id).to eq new_asset.id
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
