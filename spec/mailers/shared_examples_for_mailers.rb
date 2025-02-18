require 'rails_helper'

RSpec.shared_examples 'a mail body part' do
  it { is_expected.not_to match(/translation missing/) }

  it 'has expected contents' do
    expected_contents.each { |content| is_expected.to include content }
  end

  it { is_expected.not_to match(/\{\{.+\}\}/) }
end

RSpec.shared_examples 'a mail with headers' do
  its(:from) { is_expected.to eq [client.mail_address] }
  its(:class) { is_expected.to eq ActionMailer::MessageDelivery }
  its(:to) { is_expected.to eq [to] }
  its(:subject) { is_expected.not_to match(/translation missing/) }
end

RSpec.shared_examples 'a mail multipart body' do
  it { is_expected.to be_multipart }
  its(:parts) { is_expected.to have(2).elements }

  describe 'text' do
    subject { body.parts.first.body }

    it_behaves_like 'a mail body part'
  end

  describe 'html' do
    subject { body.parts.last.body }

    it_behaves_like 'a mail body part'
  end
end

RSpec.shared_examples 'a mail with attachment' do
  it_behaves_like 'a mail with headers'

  describe 'body' do
    subject(:body) { mail.parts.first.body }

    it_behaves_like 'a mail multipart body'
  end
end

RSpec.shared_examples 'a mail' do
  it_behaves_like 'a mail with headers'

  describe 'body' do
    subject(:body) { mail.body }

    it_behaves_like 'a mail multipart body'
  end
end
