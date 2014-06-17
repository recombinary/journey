require 'spec_helper'

describe Journey::Resource::Attachments do

  let(:klass) do 
    Class.new(Journey::Resource) do
      self.element_name = 'job'
      attachment :important_file
      attachment :boring_file
    end
  end

  describe '.attachment' do
    let(:instance) do
      klass.new(display_attachments: OpenStruct.new({
        'important_file' => OpenStruct.new({
          'original' => 'O.jpg',
          'thumbnail' => 'T.jpg'
        })
      }))
    end

    describe '##{attachment}_path' do

      it 'defaults to original size' do
        expect(instance.important_file_path).to eq 'O.jpg'
      end

      it 'returns path from #display_attachments for a given size' do
        expect(instance.important_file_path(:thumbnail)).to eq 'T.jpg'
      end

      it 'is blank when attachment doesnt exist' do
        expect(instance.boring_file_path).to be_nil
      end

      it 'handles missing display_attachments gracefully' do
        instance.display_attachments = nil
        expect{ instance.important_file_path }.not_to raise_error
      end
    end

    describe '##{attachment}_url' do
      it 'is blank when attachment doesnt exist' do
        expect(instance.boring_file_url).to be_blank
      end
    end

  end
end
