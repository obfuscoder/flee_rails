require 'rails_helper'

RSpec.describe 'admin/users/edit' do
  before do
    assign :user, create(:user)
    render
  end

  it_behaves_like 'a standard view'

  it 'renders the form' do
    expect(view).to render_template partial: 'admin/users/_form'
  end
end
