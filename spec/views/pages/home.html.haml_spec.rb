require 'rails_helper'

RSpec.describe 'pages/home.html.haml' do
  let(:events) { [FactoryGirl.create(:event), FactoryGirl.create(:event)] }
  before do
    assign(:events, events)
    render
  end

  it 'does not set content for title' do
    expect(view.content_for(:title)).to be_nil
  end

  it 'links to registration' do
    assert_select 'a[href=?]', new_seller_path
  end

  it 'links to seller resend activation' do
    assert_select 'a[href=?]', resend_activation_seller_path
  end

  it 'lists the events' do
    assert_select 'ul>li>h4', events.first.name
    assert_select 'ul>li>h4', events.last.name
  end

  context 'without events' do
    let(:events) { [] }
    it 'it displays info that there are no events' do
      expect(rendered).to match(/Aktuell sind keine/)
    end
  end
end
