# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client do
  subject(:client) { build :client, key: 'key', domain: 'somedomain.de', name: 'Flohmarkthelfer Test' }

  it { is_expected.to be_valid }
  it { is_expected.to have_many :events }
  it { is_expected.to have_many :categories }
  it { is_expected.to have_many :sellers }
  it { is_expected.to have_many :stock_items }
  it { is_expected.to have_many :users }

  it { is_expected.to validate_uniqueness_of(:key).case_insensitive }
  it { is_expected.to validate_uniqueness_of(:domain).case_insensitive }
  it { is_expected.to validate_uniqueness_of :prefix }
  it { is_expected.to validate_presence_of :key }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :terms }

  describe '#host_match?' do
    subject { client.host_match? host }
    %w[www.key.test.host key.test.host somedomain.de].each do |host_name|
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
    it { is_expected.to eq 'Flohmarkthelfer Test <key@test.host>' }
  end

  describe '#url' do
    subject { client.url }
    it { is_expected.to eq 'http://somedomain.de' }
    context 'when domain is not set' do
      before { client.domain = nil }
      it { is_expected.to eq 'http://key.test.host' }
    end
  end
end
