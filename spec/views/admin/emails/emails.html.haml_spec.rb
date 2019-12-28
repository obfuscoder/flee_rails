require 'rails_helper'

RSpec.describe 'admin/emails/emails' do
  before do
    assign :email, CustomEmail.new
    assign :json, 'something'
  end

  it_behaves_like 'a standard view'
end
