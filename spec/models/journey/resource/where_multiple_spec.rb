require 'spec_helper'

describe Journey::Resource::WhereMultiple do

  let(:klass) do
    Class.new(Journey::Resource) do
      self.element_name = 'job'

      def self.destroy_all
        all.each(&:destroy)
      end
    end
  end


  before { klass.destroy_all }

  let(:candidates) { matchables + unmatchables }

  context "when query doesn't contain any key having an array-like value" do
    let(:matchables) do
      [ klass.create(number: 'A') ]
    end
    let(:unmatchables) do
      [ klass.create(number: 'X') ]
    end

    let(:collection) { klass.where_multiple(query: { number: 'A' }) }

    it 'returns correct results' do
      expect(matchables).to be_all do |matchable|
        collection.include?(matchable)
      end
      expect(unmatchables).not_to be_any do |unmatchable|
        collection.include?(unmatchable)
      end
    end

    pending 'performs 1 query'
  end

  context "when query contains one key having an array-like value" do

    let(:matchables) do
      [
        klass.create(number: 'A'),
        klass.create(number: 'B')
      ]
    end
    let(:unmatchables) do
      [
        klass.create(number: 'X'),
        klass.create(number: 'Y')
      ]
    end

    let(:collection) { klass.where_multiple(query: { number: ['A', 'B'] }) }

    it 'returns correct results' do
      expect(matchables).to be_all do |matchable|
        collection.include?(matchable)
      end
      expect(unmatchables).not_to be_any do |unmatchable|
        collection.include?(unmatchable)
      end
    end

    pending 'performs n queries'
  end


  context "when query contains two keys having array-like values" do
    let(:matchables) do
      [
        klass.create(number: 'A', flash_number: '1'),
        klass.create(number: 'A', flash_number: '2'),
        klass.create(number: 'B', flash_number: '1'),
        klass.create(number: 'B', flash_number: '2'),
      ]
    end
    let(:unmatchables) do
      [
        klass.create(number: 'A', flash_number: '3'),
        klass.create(number: 'B', flash_number: '3'),
        klass.create(number: 'C', flash_number: '1'),
        klass.create(number: 'C', flash_number: '2'),
        klass.create(number: 'C', flash_number: '3'),
      ]
    end

    let(:collection) { klass.where_multiple(query: { number: ['A', 'B'], flash_number: ['1', '2'] }) }

    it 'returns correct results' do
      expect(matchables).to be_all do |matchable|
        collection.include?(matchable)
      end
      expect(unmatchables).not_to be_any do |unmatchable|
        collection.include?(unmatchable)
      end
    end

    pending 'performs m * n queries'
  end


end
