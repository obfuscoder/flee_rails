# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::EventsController do
  include Sorcery::TestHelpers::Rails::Controller
  let(:user) { create :user }
  let(:event) { create :event_with_ongoing_reservation, confirmed: false }

  before { login_user user }

  describe 'GET index' do
    before do
      events
      get :index
    end

    let(:events) { [event] }

    describe 'response' do
      subject { response }

      it { is_expected.to render_template :index }
      it { is_expected.to have_http_status :ok }
    end

    describe '@events' do
      subject { assigns :events }

      it { is_expected.to have(events.count).items }

      context 'when event does not have any shopping times' do
        let(:event) { create(:event).tap { |event| event.shopping_periods.clear } }

        it { is_expected.to have(events.count).items }
      end
    end
  end

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

    before { put :update, params: { id: event.id, event: event_params } }

    it 'updates confirmed' do
      expect(event.reload).to be_confirmed
    end

    it 'redirects to index path' do
      expect(response).to redirect_to admin_events_path
    end

    def to_attributes(object)
      object.attributes.map.each_with_object({}) { |(k, v), h| h[k.to_sym] = v if %w[id min max].include? k }
    end

    %w[shopping handover pickup].each do |kind|
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
          let(:event_params) { { attrib_name => [id: event.send(association).first.id, _destroy: true] } }

          it "removes #{kind} period" do
            expect(event.send(association)).not_to be_empty
            event.reload
            expect(event.send(association)).to be_empty
          end
        end
      end
    end
  end

  describe 'GET stats' do
    let(:event) { create :event }

    before { get :stats, params: { id: event.id } }

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
    let(:creator) { double call: data }
    let(:data) { 'data' }

    before do
      allow(CreateEventData).to receive(:new).and_return creator
      get :data, params: { id: event.id }
    end

    it 'uses CreateEventData' do
      expect(CreateEventData).to have_received(:new).with(Client.first)
      expect(creator).to have_received(:call).with(event)
    end

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }
      its(:content_type) { is_expected.to eq 'application/octet-stream' }
      its(:body) { is_expected.to eq data }
    end
  end

  describe 'POST create' do
    let(:event) { attributes_for(:event) }

    before { post :create, params: { event: event } }

    describe 'response' do
      subject { response }

      it { is_expected.to redirect_to admin_events_path }

      context 'when event attributes are invalid' do
        let(:event) { attributes_for :event, name: nil }

        it { is_expected.to render_template :new }
      end
    end

    context 'with reservation_fees_payed_in_advance set' do
      let(:event) { attributes_for :event, reservation_fees_payed_in_advance: true }

      it 'creates event with reservation_fees_payed_in_advance set to true' do
        expect(Event.last).to be_reservation_fees_payed_in_advance
      end
    end
  end

  describe 'GET bill' do
    let(:event) { create(:billable_event).tap(&:create_bill) }
    let(:bill) { event.bill }

    before { get :bill, params: { id: event.id } }

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }
      its(:content_type) { is_expected.to eq 'application/pdf' }
      its(:body) { is_expected.to eq bill.document }
    end
  end

  describe 'GET report' do
    before do
      allow(CreateEventReport).to receive(:new).with(event).and_return create_event_report
      get :report, params: { id: event.id }
    end

    let(:create_event_report) { double call: report }
    let(:report) { 'the report' }

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }
      its(:content_type) { is_expected.to eq 'text/plain' }
      its(:body) { is_expected.to eq report }
    end
  end

  describe 'GET labels' do
    before do
      allow(CreateLabelsDocumentJob).to receive(:perform_later)
      get :labels, params: { id: event.id }
    end

    it 'schedules the create label document job' do
      expect(CreateLabelsDocumentJob).to have_received(:perform_later).with(event)
    end

    describe 'response' do
      subject { response }

      it { is_expected.to redirect_to admin_event_path(event) }
    end

    it 'notifies about scheduled job' do
      expect(flash[:notice]).to be_present
    end
  end
end
