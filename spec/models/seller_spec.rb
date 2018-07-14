# frozen_string_literal: true

require 'rails_helper'
require 'validates_email_format_of/rspec_matcher'

RSpec.describe Seller do
  subject(:seller) { build :seller }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :client }
  it { is_expected.to validate_presence_of :client }
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :street }
  it { is_expected.to validate_presence_of :zip_code }
  it { is_expected.to validate_presence_of :city }
  it { is_expected.to validate_presence_of :phone }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive.scoped_to(:client_id) }
  it { is_expected.to validate_acceptance_of(:accept_terms).on(:create) }
  it { is_expected.to have_many :reservations }
  it { is_expected.to have_many :notifications }
  it { is_expected.to have_many :suspensions }
  it { is_expected.to have_many :emails }
  it { is_expected.to have_many :supporters }

  its(:to_s) { is_expected.to eq("#{subject.first_name} #{subject.last_name}") }

  describe '#zip_code' do
    [
      nil, 0, 1, '', ' ', '1',
      '2000', '123456', 'D-12345', 'D1234',
      ' 12345', '12345 ', '-1234', '-12345'
    ].each do |invalid_value|
      it "is invalid with value #{invalid_value}" do
        subject.zip_code = invalid_value
        expect(subject).not_to be_valid
      end
    end

    [12_345, '12345', '99999', '00000'].each do |valid_value|
      it "is valid with value #{valid_value}" do
        subject.zip_code = valid_value
        expect(subject).to be_valid
      end
    end
  end

  describe '#phone' do
    [
      nil, '', ' ', 0, 1, '+', '+49',
      '+4912345', '1', '2000', '012345', '123456',
      'abcd', '/ 2', ' 00000', '01345/-', '-1234', '-12345 /'
    ].each do |invalid_value|
      it "is invalid with value #{invalid_value}" do
        subject.phone = invalid_value
        expect(subject).not_to be_valid
      end
    end

    [
      '01234567', '+49 1523 / 378-9600', '+49(0)1523/3789600',
      '+49 (1523) 378-9600', '+4915233789600'
    ].each do |valid_value|
      it "is valid with value #{valid_value}" do
        subject.phone = valid_value
        expect(subject).to be_valid
      end
    end
  end

  describe '#email' do
    [
      nil, '', ' ', 'invalid@example.', 'email', '@example.com',
      'my email@example.com1', 'email123-€@example.com'
    ].each do |invalid_value|
      it "is invalid with value #{invalid_value}" do
        subject.email = invalid_value
        expect(subject).not_to be_valid
      end
    end

    %w[valid@example.com valid_name@sub.domain.name nee.domain-works@company.berlin].each do |valid_value|
      it "is valid with value #{valid_value}" do
        subject.email = valid_value
        expect(subject).to be_valid
      end
    end

    it 'stores in lowercase' do
      subject.email.upcase!
      subject.save
      expect(subject.email).to eq(subject.email.downcase)
    end
  end

  describe '#token' do
    let(:another_seller) { create(:seller) }
    let(:yet_another_seller) { create(:seller) }

    it 'is a unique random string' do
      subject.save
      expect(subject.token).not_to eq(another_seller.token)
      expect(subject.token).not_to eq(yet_another_seller.token)
    end
  end

  describe '#destroy' do
    before { seller.save }
    subject(:action) { seller.destroy }
    it 'does not delete record' do
      expect { action }.not_to change { Seller.with_deleted.count }
    end

    it 'destroys associated notifications, suspensions and emails' do
      create :notification, seller: seller
      create :suspension, seller: seller
      create :email, seller: seller
      seller.reload
      expect(seller.notifications).not_to be_empty
      expect(seller.emails).not_to be_empty
      expect(seller.suspensions).not_to be_empty
      action
      expect(seller.notifications).to be_empty
      expect(seller.emails).to be_empty
      expect(seller.suspensions).to be_empty
    end

    it 'marks record as deleted' do
      expect { action }.to change { seller.deleted_at }.from(nil)
    end

    it 'removes sensitive seller information' do
      action
      expect(seller.email).to be_nil
      expect(seller.first_name).to be_nil
      expect(seller.last_name).to be_nil
      expect(seller.street).to be_nil
      expect(seller.city).to be_nil
      expect(seller.phone).to be_nil
      expect(seller.token).to be_nil
      expect(seller.active).to be_nil
      expect(seller.mailing).to be_nil
    end
  end
end
