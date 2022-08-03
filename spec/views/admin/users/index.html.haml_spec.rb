require 'rails_helper'

RSpec.describe 'admin/users/index' do
  let(:admin) { create :user }
  let(:more_users) { create_list :user, 25 }
  let(:users) { [admin] + more_users }

  before do
    allow(view).to receive(:current_user).and_return admin
    assign :users, users.paginate
  end

  it_behaves_like 'a standard view'

  it 'has column sort links' do
    expect_any_instance_of(ApplicationHelper).to receive(:sort_link_to).with(User, :name)
    expect_any_instance_of(ApplicationHelper).to receive(:sort_link_to).with(User, :email)
    render
  end

  it 'shows list of first 10 users with buttons for show, edit and delete' do
    render
    users.take(10).each do |user|
      expect(rendered).to have_content user.name
      expect(rendered).to have_content user.email
      expect(rendered).to have_link href: edit_admin_user_path(user)
      expect(rendered).to have_css "a[data-link='#{admin_user_path(user)}']" if user != admin
    end
  end

  it 'does not link to destroy current user' do
    render
    expect(rendered).not_to have_css "a[data-link='#{admin_user_path(admin)}']"
  end
end
