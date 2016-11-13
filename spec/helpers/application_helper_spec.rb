require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#brand_key' do
    subject(:action) { helper.brand_key }
    it { is_expected.to eq 'demo' }

    context 'when settings include mapping for foo.localhost to foo' do
      before { allow(Settings.hosts).to receive(:to_h).and_return('foo.localhost' => 'foo') }
      {
        'foo.localhost.com' => 'default',
        'foo.localhost' => 'foo',
        'www.foo.localhost' => 'foo'
      }.each do |host, brand|
        context "when request host is #{host}" do
          before { controller.request.host = host }
          it { is_expected.to eq brand }
        end
      end
    end
  end
end
