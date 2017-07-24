# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'layouts/application' do
  before { allow(view).to receive(:searchable?) { false } }

  describe 'navigation bar' do
    before do
      render
    end

    it 'links to home page' do
      expect(rendered).to have_link href: root_path
    end

    it 'links to contact page' do
      expect(rendered).to have_link href: pages_contact_path
    end

    it 'links to imprint page' do
      expect(rendered).to have_link href: pages_imprint_path
    end

    it 'links to privacy page' do
      expect(rendered).to have_link href: pages_privacy_path
    end

    it 'links to terms page' do
      expect(rendered).to have_link href: pages_terms_path
    end
  end

  describe 'search form' do
    it 'is not shown' do
      render
      expect(rendered).not_to have_field 'Suche'
    end

    context 'when searchable' do
      before { allow(view).to receive(:searchable?) { true } }
      it 'is shown' do
        render
        expect(rendered).to have_field 'Suche'
      end
    end
  end

  describe 'title' do
    context 'without content for title' do
      it 'uses standard title' do
        render
        assert_select 'title', 'Flohmarkthelfer Demo'
      end
    end

    context 'with content for title' do
      it 'uses standard title and content for title' do
        view.instance_variable_get('@view_flow').set(:title, 'Test Title')
        render
        assert_select 'title', 'Flohmarkthelfer Demo - Test Title'
      end
    end
  end
end
