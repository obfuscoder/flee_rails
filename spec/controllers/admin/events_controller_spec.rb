require 'rails_helper'

module Admin
  RSpec.describe EventsController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { create :user }
    before { login_user user }

    let(:event) { create :event, confirmed: false }

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
  end
end
