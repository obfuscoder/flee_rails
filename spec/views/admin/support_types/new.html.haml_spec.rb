require 'rails_helper'

RSpec.describe 'admin/support_types/new' do
  let(:event) { create :event }

  before { assign :event, event }

  before { assign :support_type, event.support_types.build }

  before { render }

  it_behaves_like 'a standard view'

  it 'renders the form' do
    expect(view).to render_template partial: 'admin/support_types/_form'
  end
end
