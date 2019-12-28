require 'rails_helper'

RSpec.describe 'admin/supporters/_form' do
  let(:event) { create :event }
  let(:support_type) { create :support_type, event: event }
  let(:supporter) { build :supporter, support_type: support_type }
  let(:sellers) { build_list :seller, 3 }

  before do
    assign :event, event
    assign :support_type, support_type
    assign :supporter, supporter
  end

  it_behaves_like 'a standard partial'

  describe 'rendered' do
    subject { rendered }

    before do
      preparations
      render
    end

    let(:preparations) {}

    it { is_expected.to have_field 'supporter_comments' }
    it { is_expected.not_to have_field 'supporter_seller_id' }

    context 'when @sellers is defined' do
      let(:preparations) { assign :sellers, sellers }

      it { is_expected.to have_field 'supporter_seller_id' }
    end
  end
end
