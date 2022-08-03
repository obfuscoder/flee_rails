require 'rails_helper'

RSpec.describe 'admin/users/new' do
  before do
    assign :user, build(:user)
    render
  end

  it_behaves_like 'a standard view'

  it 'renders the form' do
    expect(view).to render_template partial: 'admin/users/_form'
  end
end
