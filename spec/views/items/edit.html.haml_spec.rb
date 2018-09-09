# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'items/edit' do
  let(:item) { create :item }
  let(:reservation) { item.reservation }
  let(:event) { reservation.event }

  before do
    assign :item, item
    assign :event, event
    assign :reservation, reservation
  end

  before { render }

  it_behaves_like 'a standard view'

  it 'renders the form' do
    expect(view).to render_template partial: 'items/_form'
  end
end
