require 'rails_helper'

RSpec.shared_examples 'a standard view' do
  it 'renders' do
    render
  end

  it 'sets content for title' do
    render
    expect(view.content_for(:title)).not_to be_nil
  end

  it 'does not contain missing translations' do
    render

    @view.view_flow.content.values.each { |value| expect(value).not_to have_content 'translation missing' }
    expect(rendered).not_to have_content 'translation missing'
  end
end
