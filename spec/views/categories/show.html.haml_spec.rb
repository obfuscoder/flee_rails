require 'rails_helper'

RSpec.describe "categories/show" do
  before(:each) do
    @category = assign(:category, FactoryGirl.create(:category))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
