require 'rails_helper'

RSpec.describe "categories/new" do
  before(:each) do
    assign(:category, FactoryGirl.build(:category))
  end

  it_behaves_like "a standard view"

  it "renders new category form" do
    render

    assert_select "form[action=?][method=?]", categories_path, "post" do

      assert_select "input#category_name[name=?]", "category[name]"
    end
  end
end
