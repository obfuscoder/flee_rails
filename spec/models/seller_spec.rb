require 'rails_helper'
require "validates_email_format_of/rspec_matcher"

RSpec.describe Seller do
  subject { FactoryGirl.build(:seller) }

  it { should be_valid }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:street) }
  it { should validate_presence_of(:zip_code) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:phone) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_acceptance_of(:accept_terms).on(:create) }
  it { should have_many(:item).dependent(:destroy) }
  it { should have_many(:reservation).dependent(:destroy) }
  its(:to_s) { should eq("#{subject.first_name} #{subject.last_name}") }

  describe '#zip_code' do
    [nil, 0, 1, "", " ", "1", "2000", "123456", "D-12345", "D1234", " 12345", "12345 ", "-1234", "-12345"].each do |invalid_value|
      it "is invalid with value #{invalid_value}" do
        subject.zip_code = invalid_value
        expect(subject).not_to be_valid
      end
    end

    [12345, "12345", "99999", "00000"].each do |valid_value|
      it "is valid with value #{valid_value}" do
        subject.zip_code = valid_value
        expect(subject).to be_valid
      end
    end
  end

  describe '#phone' do
    [nil, "", " ", 0, 1, "+", "+49", "+4912345", "1", "2000", "012345", "123456", "abcd", "/ 2", " 00000", "01345/-", "-1234", "-12345 /"].each do |invalid_value|
      it "is invalid with value #{invalid_value}" do
        subject.phone = invalid_value
        expect(subject).not_to be_valid
      end
    end

    ["01234567", "+49 1523 / 378-9600", "+49(0)1523/3789600", "+49 (1523) 378-9600", "+4915233789600"].each do |valid_value|
      it "is valid with value #{valid_value}" do
        subject.phone = valid_value
        expect(subject).to be_valid
      end
    end
  end

  describe '#email' do
    [nil, "", " ", "invalid@example.", "email", "@example.com", "my email@example.com1", "email123-€@example.com"].each do |invalid_value|
      it "is invalid with value #{invalid_value}" do
        subject.email= invalid_value
        expect(subject).not_to be_valid
      end
    end

    ["valid@example.com", "valid_name@sub.domain.name", "nee.domain-works@company.berlin"].each do |valid_value|
      it "is valid with value #{valid_value}" do
        subject.email = valid_value
        expect(subject).to be_valid
      end
    end

    it "stores in lowercase" do
      subject.email.upcase!
      subject.save
      expect(subject.email).to eq(subject.email.downcase)
    end
  end
end
