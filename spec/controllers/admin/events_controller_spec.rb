require 'rails_helper'

module Admin
  RSpec.describe EventsController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { FactoryGirl.create :user }
    before { login_user user }

    let(:event) { FactoryGirl.create :event, confirmed: false }

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

      it 'redirects to sellers path' do
        expect(response).to redirect_to admin_events_path
      end

      def to_attributes(object)
        object.attributes.map.each_with_object({}) { |(k, v), h| h[k.to_sym] = v if %w(id min max).include? k }
      end

      %w(shopping handover).each do |kind|
        context "when updating #{kind} times" do
          let(:association) { "#{kind}_periods" }
          let(:attrib_name) { "#{kind}_periods_attributes" }
          let(:period1) { to_attributes event.send(association).first }
          let(:period2) { FactoryGirl.attributes_for "#{kind}_period", min: 2.weeks.from_now + 30.minutes }
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
  end
end
