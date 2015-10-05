require 'spec_helper'

describe Journey::Resource::BatchWhere do

  let(:klass) do
    Class.new(Journey::Resource) do
      self.element_name = 'technician'
    end
  end

  let(:surname) { SecureRandom.uuid }
  let(:batch_size) { 2 }

  let!(:objects) do
    (1..5).to_a.map do |index|
      klass.create(name: index, surname: surname)
    end
  end

  it 'returns the correct resources' do
    candidates = klass.batch_where({ query: { surname: surname } }, batch_size)
    expect(objects).to eq candidates
  end

  it 'makes multiple queries' do
    expect(klass).to receive(:where_multiple).exactly(3).times
    klass.batch_where({ query: { surname: surname } }, batch_size)
  end

end
