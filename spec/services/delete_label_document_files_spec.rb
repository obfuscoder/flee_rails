require 'rails_helper'

RSpec.describe DeleteLabelDocumentFiles do
  subject(:instance) { described_class.new event }

  let(:event) { double id: 123 }

  describe '#call' do
    subject(:action) { instance.call }

    let(:files) { %w[path/to/file path/to/file2] }

    before do
      allow(Dir).to receive(:glob).and_return(files)
      allow(File).to receive(:delete)
      action
    end

    it 'deletes all related files in download/labels folder' do
      expect(Dir).to have_received(:glob).with 'public/download/labels/123_*.pdf'
      files.each { |file| expect(File).to have_received(:delete).with(file) }
    end
  end
end
