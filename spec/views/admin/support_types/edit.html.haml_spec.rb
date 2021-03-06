require 'rails_helper'

RSpec.describe 'admin/support_types/edit' do
  let(:event) { create :event }

  before do
    assign :event, event
    assign :support_type, create(:support_type, event: event)
  end

  before { render }

  it_behaves_like 'a standard view'

  it 'renders the form' do
    expect(view).to render_template partial: 'admin/support_types/_form'
  end
end
