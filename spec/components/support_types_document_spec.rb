require 'rails_helper'

RSpec.describe SupportTypesDocument do
  subject(:document) { described_class.new event, support_types }

  let(:event) { create :event }
  let(:support_types) { create_list :support_type, 2, event: event }
  let!(:supporters1) { create_list :supporter, 3, support_type: support_types.first }
  let!(:supporters2) { create_list :supporter, 4, support_type: support_types.last }
  let!(:supporters) { supporters1 + supporters2 }
  let!(:sellers) { supporters.map(&:seller) }

  describe '#render' do
    let(:output) { PDF::Inspector::Text.analyze(document.render).strings }

    it 'contains event infos, support types and seller names with comments' do
      expect(output).to include event.name
      support_types.each { |support_type| expect(output).to include support_type.name }
      supporters.each { |supporter| expect(output).to include "#{supporter.seller.name} (#{supporter.comments})" }
    end
  end
end
