require 'rails_helper'

RSpec.describe 'layouts/application' do
  before { allow(view).to receive(:searchable?) { false } }
  describe 'navigation bar' do
    before do
      render
    end

    it 'links to home page' do
      assert_select '.navbar ul>li>a[href=?]', root_path
    end

    it 'links to contact page' do
      assert_select '.navbar ul>li>a[href=?]', pages_contact_path
    end

    it 'links to imprint page' do
      assert_select '.navbar ul>li>a[href=?]', pages_imprint_path
    end

    it 'links to privacy page' do
      assert_select '.navbar ul>li>a[href=?]', pages_privacy_path
    end
  end

  describe 'title' do
    context 'without content for title' do
      it 'uses standard title' do
        render
        assert_select 'title', 'Flohmarkthelfer'
      end
    end

    context 'with content for title' do
      it 'uses standard title and content for title' do
        view.instance_variable_get('@view_flow').set(:title, 'Test Title')
        render
        assert_select 'title', 'Flohmarkthelfer - Test Title'
      end
    end
  end
end
