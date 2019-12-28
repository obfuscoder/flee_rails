require 'rails_helper'

RSpec.describe 'admin/supporters/edit' do
  let(:event) { create :event }
  let(:support_type) { create :support_type, event: event }

  before do
    assign :event, event
    assign :support_type, support_type
    assign :supporter, create(:supporter, support_type: support_type)
  end

  before { render }

  it_behaves_like 'a standard view'

  it 'renders the form' do
    expect(view).to render_template partial: 'admin/supporters/_form'
  end
end
