require 'spec_helper'


describe Journey::Oplog do

  it 'compensates for reserved attribute #data' do
    oplog = Journey::Oplog.last
    expect(oplog.content).to_not be_blank
  end

end
