# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/message_templates/edit' do
  before { assign :message_template, create(:registration_message_template) }

  it_behaves_like 'a standard view'

  describe 'rendered' do
    before { render }
    subject { rendered }

    it { is_expected.to have_field 'message_template_subject' }
    it { is_expected.to have_field 'message_template_body' }
  end
end
