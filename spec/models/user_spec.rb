require 'rails_helper'

RSpec.describe User do
  subject(:user) { build :user }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :client }
  it { is_expected.to validate_presence_of :client }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive.scoped_to(:client_id) }

  its(:to_s) { is_expected.to eq user.name }

  context 'when name is not set' do
    subject(:user) { build :user, name: nil }

    its(:to_s) { is_expected.to eq user.email }
  end

  describe '#email' do
    [
      nil, '', ' ', 'invalid@example.', 'email', '@example.com',
      'my email@example.com1', 'email123-€@example.com'
    ].each do |invalid_value|
      it "is invalid with value #{invalid_value}" do
        user.email = invalid_value
        expect(user).not_to be_valid
      end
    end

    %w[valid@example.com valid_name@sub.domain.name nee.domain-works@company.berlin].each do |valid_value|
      it "is valid with value #{valid_value}" do
        user.email = valid_value
        expect(user).to be_valid
      end
    end

    it 'stores in lowercase' do
      user.email.upcase!
      user.save
      expect(user.email).to eq(user.email.downcase)
    end
  end
end
