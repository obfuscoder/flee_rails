require 'rails_helper'

RSpec.describe "pages/home.html.haml" do
  let(:events) { [FactoryGirl.create(:event), FactoryGirl.create(:event)] }
  before do
    assign(:events, events)
    render
  end

  it "links to registration" do
    assert_select "a[href=?]", new_seller_path
  end

  it "links to seller resend activation" do
    assert_select "a[href=?]", resend_activation_sellers_path
  end

  it "lists the upcoming events" do
    assert_select "ul>li>h4", text: events.first.name, count: 1
    assert_select "ul>li>h4", text: events.last.name, count: 1
  end
end
