require 'rails_helper'

RSpec.describe Admin::EventsController do
  include Sorcery::TestHelpers::Rails::Controller
  let(:user) { create :user }
  before { login_user user }

  let(:event) { create :event_with_ongoing_reservation, confirmed: false }

  describe 'GET new' do
    before { get :new }
    describe 'response' do
      subject { response }
      it { is_expected.to render_template :new }
      it { is_expected.to have_http_status :ok }
    end
    describe '@event' do
      subject { assigns :event }
      it { is_expected.to be_a_new Event }
    end
  end

  describe 'PUT update' do
    let(:event_params) { { confirmed: true } }
    before { put :update, id: event.id, event: event_params }

    it 'updates confirmed' do
      expect(event.reload).to be_confirmed
    end

    it 'redirects to index path' do
      expect(response).to redirect_to admin_events_path
    end

    def to_attributes(object)
      object.attributes.map.each_with_object({}) { |(k, v), h| h[k.to_sym] = v if %w(id min max).include? k }
    end

    %w(shopping handover pickup).each do |kind|
      context "when updating #{kind} times" do
        let(:association) { "#{kind}_periods" }
        let(:attrib_name) { "#{kind}_periods_attributes" }
        let(:period1) { to_attributes event.send(association).first }
        let(:period2) { attributes_for "#{kind}_period", min: 2.weeks.from_now + 30.minutes }
        let(:event_params) { { attrib_name => [period1, period2] } }

        it "persists #{kind} times" do
          event.reload
          expect(event.send(association).first.min.to_i).to eq period1[:min].to_i
          expect(event.send(association).first.max.to_i).to eq period1[:max].to_i
          expect(event.send(association).last.min.to_i).to eq period2[:min].to_i
          expect(event.send(association).last.max.to_i).to eq period2[:max].to_i
        end

        context "when removing a #{kind} period" do
          before { expect(event.send(association)).not_to be_empty }
          let(:event_params) { { attrib_name => [id: event.send(association).first.id, _destroy: true] } }

          it "removes #{kind} period" do
            event.reload
            expect(event.send(association)).to be_empty
          end
        end
      end
    end
  end

  describe 'GET stats' do
    let(:event) { create :event }
    before { get :stats, id: event.id }
    describe 'response' do
      subject { response }
      it { is_expected.to render_template :stats }
      it { is_expected.to have_http_status :ok }
    end
    describe '@event' do
      subject { assigns :event }
      it { is_expected.to eq event }
    end
  end

  describe 'GET data' do
    let(:event) { create :event }
    let!(:categories) { create_list :category, 5 }
    before { get :data, id: event.id }
    describe 'response' do
      subject { response }
      it { is_expected.to have_http_status :ok }
      its(:content_type) { is_expected.to eq 'application/octet-stream' }
    end

    describe 'body' do
      subject { JSON.parse ActiveSupport::Gzip.decompress(response.body), symbolize_names: true }
      it do
        is_expected.to include :id, :name, :price_precision, :commission_rate, :seller_fee,
                               :donation_of_unsold_items_enabled
      end
      it { is_expected.to include :categories, :sellers, :items, :reservations }
    end
  end

  describe 'GET items_per_category' do
    before do
      expect_any_instance_of(Event).to receive(:items_per_category).and_return([['Cat1', 3], ['Cat2', 2]])
      get :items_per_category, id: event.id
    end

    describe 'response' do
      subject { response }
      it { is_expected.to have_http_status :ok }
      its(:content_type) { is_expected.to eq 'application/json' }
      describe 'body' do
        subject { response.body }
        it { is_expected.to eq '[["Cat1",3],["Cat2",2]]' }
      end
    end
  end

  describe 'GET sold_items_per_category' do
    before do
      expect_any_instance_of(Event).to receive(:sold_items_per_category).and_return([['Cat1', 3], ['Cat2', 2]])
      get :sold_items_per_category, id: event.id
    end

    describe 'response' do
      subject { response }
      it { is_expected.to have_http_status :ok }
      its(:content_type) { is_expected.to eq 'application/json' }
      describe 'body' do
        subject { response.body }
        it { is_expected.to eq '[["Cat1",3],["Cat2",2]]' }
      end
    end
  end

  describe 'GET sellers_per_city' do
    before do
      expect_any_instance_of(Event).to receive(:sellers_per_zip_code).and_return(
        [
          double(zip_code: '75203', count: 3),
          double(zip_code: '71229', count: 2),
          double(zip_code: '76131', count: 1),
          double(zip_code: '76139', count: 1)
        ])
      get :sellers_per_city, id: event.id
    end

    describe 'response' do
      subject { response }
      it { is_expected.to have_http_status :ok }
      its(:content_type) { is_expected.to eq 'application/json' }
      describe 'body' do
        subject { JSON.parse response.body }
        it { is_expected.to eq [['Königsbach-Stein', 3], ['Leonberg', 2], ['Karlsruhe', 2]] }
      end
    end
  end

  describe 'POST create' do
    let(:event) { attributes_for(:event) }
    before { post :create, event: event }

    describe 'response' do
      subject { response }
      it { is_expected.to redirect_to admin_events_path }

      context 'when event attributes are invalid' do
        let(:event) { attributes_for(:event).tap { |event| event['name'] = nil } }
        it { is_expected.to render_template :new }
      end
    end
  end
end
