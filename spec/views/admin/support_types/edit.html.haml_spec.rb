# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/support_types/edit' do
  let(:event) { create :event }
  before do
    assign :event, event
    assign :support_type, create(:support_type, event: event)
  end

  it_behaves_like 'a standard view'

  before { render }

  it 'renders the form' do
    expect(view).to render_template partial: 'admin/support_types/_form'
  end
end
