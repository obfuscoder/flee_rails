# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client do
  subject(:client) { build :demo_client }

  it { is_expected.to be_valid }

  describe '#host_match?' do
    subject { client.host_match? host }
    %w[www.demo.test.host demo.test.host test.host].each do |host_name|
      context "when host is #{host_name}" do
        let(:host) { host_name }
        it { is_expected.to eq true }
      end
    end
  end

  describe '#short_name' do
    subject { client.short_name }
    it { is_expected.to eq client.name }
  end

  describe '#mail_from' do
    subject { client.mail_from }
    it { is_expected.to eq 'Flohmarkthelfer Demo <demo@test.host>' }
  end

  describe '#database' do
    let(:database) { double }
    let(:brands) do
      double.tap do |d|
        allow(d).to receive(:try).with('demo').and_return(double(database: database))
      end
    end
    before { allow(Settings).to receive(:brands).and_return(brands) }
    subject { client.database }
    it { is_expected.to eq database }
  end

  describe '#url' do
    subject { client.url }
    it { is_expected.to eq 'http://test.host' }
    context 'when domain is not set' do
      before { client.domain = nil }
      it { is_expected.to eq 'http://demo.test.host' }
    end
  end
end
