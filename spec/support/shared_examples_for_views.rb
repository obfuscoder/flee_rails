# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a standard partial' do
  it 'renders' do
    render
  end

  it 'does not contain missing translations' do
    render

    @view.view_flow.content.each_value { |value| expect(value).not_to have_content 'translation missing' }
    expect(rendered).not_to have_content 'translation missing'
  end
end

RSpec.shared_examples 'a standard view' do
  it_behaves_like 'a standard partial'

  it 'sets content for title' do
    render
    expect(view.content_for(:title)).not_to be_nil
  end
end
