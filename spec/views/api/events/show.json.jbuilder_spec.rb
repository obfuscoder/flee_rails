require 'rails_helper'

RSpec.describe 'api/events/show' do
  before do
    event = FactoryGirl.create :event_with_ongoing_reservation
    reservations = FactoryGirl.create_list :reservation, 2, event: event
    FactoryGirl.create_list :item, 3, reservation: reservations.first
    FactoryGirl.create_list :item, 2, reservation: reservations.second

    assign :event, event.reload
    assign :categories, Category.all
    render
  end

  subject(:json) { JSON.parse rendered, symbolize_names: true }

  it { is_expected.to include :id, :name }
  it { is_expected.to include :price_precision, :commission_rate, :seller_fee, :donation_of_unsold_items_enabled }
  it { is_expected.to include :categories }

  describe 'categories' do
    subject(:categories) { json[:categories] }
    it { is_expected.to have(5).items }
    it 'have id and name' do
      categories.each { |category| expect(category).to include :id, :name }
    end
  end

  describe 'sellers' do
    subject(:sellers) { json[:sellers] }
    it { is_expected.to have(2).items }
    it 'have id and name' do
      sellers.each do |seller|
        expect(seller).to include :id, :first_name, :last_name, :street, :zip_code, :city, :phone, :email
      end
    end
  end

  describe 'reservations' do
    subject(:reservations) { json[:reservations] }
    it { is_expected.to have(2).items }

    it 'have necessary attributes' do
      reservations.each { |reservation| expect(reservation).to include :id, :number, :seller_id }
    end
  end

  describe 'items' do
    subject(:items) { json[:items] }
    it { is_expected.to have(5).items }

    it 'have necessary attributes' do
      items.each do |item|
        expect(item).to include :id, :category_id, :reservation_id, :description,
                                :number, :code, :sold, :donation, :size, :price
      end
    end
  end
end
