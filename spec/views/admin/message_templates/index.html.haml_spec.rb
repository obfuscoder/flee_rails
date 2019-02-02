# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/message_templates/index' do
  let(:message_template) { create :registration_message_template }

  before { assign :message_templates, [message_template] }

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject(:output) { rendered }

    before { render }

    it { is_expected.to have_content message_template.subject }
    it { is_expected.to have_link href: edit_admin_message_template_path(message_template) }
    it { is_expected.to have_css "a[data-link='#{admin_message_template_path(message_template)}']" }
    it { is_expected.to have_css '#confirm-modal' }
  end
end
