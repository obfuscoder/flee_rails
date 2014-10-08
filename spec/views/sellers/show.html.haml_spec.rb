require 'rails_helper'

RSpec.describe "sellers/show", :type => :view do
  before(:each) do
    @seller = assign(:seller, Seller.create!(
      :first_name => "First Name",
      :last_name => "Last Name",
      :street => "Street",
      :zip_code => "Zip Code",
      :city => "City",
      :email => "Email",
      :phone => "Phone"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Street/)
    expect(rendered).to match(/Zip Code/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Phone/)
  end
end
