# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#current_client' do
    let(:demo_client) { Client.find_by key: 'demo' }
    subject(:action) { helper.current_client }
    it { is_expected.to eq demo_client }

    context 'with other client' do
      before { demo_client.update domain: nil }
      let!(:client) { create :client }
      context 'when client matches host' do
        before { @request.host = "#{client.key}.test.host" }
        it { is_expected.to eq client }
      end

      context 'when client does not match host' do
        before { @request.host = 'unknown.test.host' }
        it { is_expected.to eq Settings.default_client }
      end
    end
  end
end
