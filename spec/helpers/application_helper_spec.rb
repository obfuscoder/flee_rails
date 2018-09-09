# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#current_client' do
    subject(:action) { helper.current_client }

    let(:demo_client) { Client.find_by key: 'demo' }
    let!(:other_client) { create :client, key: 'other', domain: 'otherdomain.de' }
    let(:default_client) { Settings.default_client }

    {
      'test.host' => nil,
      'demo.test.host' => 'demo',
      'other.test.host' => 'other',
      'www.otherdomain.de' => 'other',
      'unknown.test.host' => nil
    }.each do |host, expected_key|
      context "when request host is #{host}" do
        before { @request.host = host }

        its(:key) { is_expected.to eq expected_key }
      end
    end
  end
end
