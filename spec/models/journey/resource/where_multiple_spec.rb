require 'spec_helper'

describe Journey::Resource::WhereMultiple do

  let(:klass) do
    Class.new(Journey::Resource) do
      self.element_name = 'job'
    end
  end

  before { klass.all.each(&:destroy) }

  let!(:candidates) { matchables + unmatchables }
  let(:collection) { klass.where_multiple(clauses) }
  let(:count) { klass.count_multiple(clauses) }

  context "when query doesn't contain any key having an array-like value" do
    let(:clauses) do
      { query: { number: 'A' } }
    end

    let(:matchables) do
      [ klass.create(number: 'A') ]
    end
    let(:unmatchables) do
      [ klass.create(number: 'X') ]
    end


    it 'returns correct results' do
      expect(matchables).to be_all do |matchable|
        collection.include?(matchable)
      end
      expect(unmatchables).not_to be_any do |unmatchable|
        collection.include?(unmatchable)
      end
    end

    it 'counts correctly' do
      expect(count).to eq 1
    end

    pending 'performs 1 query'
  end

  context "when query contains a key with the value of an array containing a single item" do
    let(:clauses) do
      { query: { number: ['A'] }, sort: { number: :desc } }
    end
    let(:matchables) do
      [
        klass.create(number: 'A')
      ]
    end
    let(:unmatchables) do
      [
        klass.create(number: 'B')
      ]
    end

    it 'returns correct results' do
      expect(matchables).to be_all do |matchable|
        collection.include?(matchable)
      end
      expect(unmatchables).not_to be_any do |unmatchable|
        collection.include?(unmatchable)
      end
    end

    it 'counts correctly' do
      expect(count).to eq 1
    end

    pending 'performs n queries'

  end

  context "when query contains one key having an array-like value" do
    let(:clauses) do
      { query: { number: ['A', 'B'] } }
    end
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

    it 'returns correct results' do
      expect(matchables).to be_all do |matchable|
        collection.include?(matchable)
      end
      expect(unmatchables).not_to be_any do |unmatchable|
        collection.include?(unmatchable)
      end
    end

    it 'counts correctly' do
      expect(count).to eq 2
    end

    pending 'performs n queries'
  end


  context "when query contains two keys having array-like values" do
    let(:clauses) do
      { query: { number: ['A', 'B'], flash_number: ['1', '2'] } }
    end
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

    it 'returns correct results' do
      expect(matchables).to be_all do |matchable|
        collection.include?(matchable)
      end
      expect(unmatchables).not_to be_any do |unmatchable|
        collection.include?(unmatchable)
      end
    end

    it 'counts correctly' do
      expect(count).to eq 4
    end

    pending 'performs m * n queries'
  end


end
