# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client do
  subject(:client) { create :client, key: 'key', domain: 'somedomain.de', name: 'Flohmarkthelfer Test' }

  it { is_expected.to be_valid }
  it { is_expected.to have_many :events }
  it { is_expected.to have_many :categories }
  it { is_expected.to have_many :sellers }
  it { is_expected.to have_many :stock_items }
  it { is_expected.to have_many :users }
  it { is_expected.to have_many :message_templates }

  it { is_expected.to validate_uniqueness_of(:key).case_insensitive }
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

    context 'when short_name is empty' do
      before { client.short_name = '' }
      it { is_expected.to eq client.name }
    end
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

  describe '#destroy_everything!' do
    let!(:category) { create :category, client: client }
    let!(:event) { create :event_with_ongoing_reservation, client: client }
    let!(:seller) { create :seller, client: client }
    let!(:stock_item) { create :stock_item, client: client }
    let!(:user) { create :user, client: client }
    let!(:email) { create :email, seller: seller }
    let!(:reservation) { create :reservation, seller: seller, event: event }
    let!(:item) { create :item, reservation: reservation }
    let!(:message) { create :invitation_message, event: event }
    let!(:notification) { create :notification, event: event, seller: seller }
    let!(:rental) { create :rental, event: event }
    let!(:review) { create :review, reservation: reservation }
    let!(:sold_stock_item) { create :sold_stock_item, stock_item: stock_item }
    let!(:suspension) { create :suspension, event: event, seller: seller }
    let!(:time_period) { event.shopping_periods.first }
    let!(:message_template) { create :message_template, client: client }

    before { client.destroy_everything! }

    it 'destroys associated data' do
      expect { category.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { seller.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { event.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { stock_item.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { user.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { email.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { reservation.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { item.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { message.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { notification.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { rental.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { review.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { sold_stock_item.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { suspension.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { time_period.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { message_template.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
