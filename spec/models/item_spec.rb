# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item do
  subject(:item) { build :item }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:reservation) }
  it { is_expected.to validate_presence_of(:category) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_length_of(:description).is_at_most(250) }
  it { is_expected.to validate_length_of(:size).is_at_most(50) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:number).is_greater_than(0) }
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:reservation_id) }
  it { is_expected.to validate_uniqueness_of(:code).scoped_to(:reservation_id) }
  it { is_expected.to belong_to(:category) }
  it { is_expected.to belong_to(:reservation) }
  it { is_expected.to have_many(:item_transactions).through(:transaction_items) }
  it { is_expected.to have_many(:transaction_items).dependent(:restrict_with_error) }

  describe '#to_s' do
    its(:to_s) { is_expected.to eq(item.description) }

    context 'without description' do
      subject(:instance) { described_class.new }

      it 'calls superclass' do
        expect(instance.to_s).to eq(instance.class.superclass.instance_method(:to_s).bind(instance).call)
      end
    end
  end

  describe '#create_code' do
    subject(:item) { build :item, reservation: reservation }

    let(:options) { {} }
    let(:preparations) {}
    let(:reservation) { create :reservation }

    before do
      preparations
      item.create_code options
    end

    its(:code) { is_expected.to eq '010010019' }
    its(:number) { is_expected.to eq 1 }

    context 'when label for other item was created already' do
      let(:preparations) { create :item_with_code, reservation: reservation }

      its(:number) { is_expected.to eq 2 }
    end

    context 'with prefix option' do
      let(:options) { { prefix: 'ABC' } }

      its(:code) { is_expected.to eq 'ABC010010019' }
    end

    context 'when code was deleted before' do
      let(:preparations) do
        item.create_code
        item.delete_code
      end

      its(:number) { is_expected.to eq 2 }
      its(:code) { is_expected.to eq '010010024' }
    end
  end

  describe '#max_items_for_category' do
    let(:category) { create :category, max_items_per_seller: 1 }
    let(:reservation) { create :reservation }

    context 'when limit is not yet reached' do
      it 'allows to create items for the category' do
        expect { create :item, category: category, reservation: reservation }.not_to raise_error
      end
    end

    context 'when limit has been reached' do
      let!(:existing_item) { create :item, category: category, reservation: reservation }

      context 'with the limit being reached for the parent category' do
        let(:child_category) { create :category, parent: category }

        it 'does not allow to create additional items for the category' do
          expect do
            create :item, category: child_category, reservation: reservation
          end.to raise_error ActiveRecord::RecordInvalid
        end
      end

      it 'does not allow to create additional items for the category' do
        expect { create :item, category: category, reservation: reservation }.to raise_error ActiveRecord::RecordInvalid
      end

      it 'does not allow to change existing item to the category' do
        item = create :item, reservation: reservation
        expect { item.update! category: category }.to raise_error ActiveRecord::RecordInvalid
      end

      it 'allows updating existing item for that category' do
        expect { existing_item.update! description: 'xxxxx' }.not_to raise_error
      end

      context 'when reservation cab ignore category limits' do
        let(:reservation) { create :reservation, category_limits_ignored: true }

        it 'allows to create additional items for the category' do
          expect { create :item, category: category, reservation: reservation }.not_to raise_error
        end

        it 'allows to change existing item to the category' do
          item = create :item, reservation: reservation
          expect { item.update! category: category }.not_to raise_error
        end
      end
    end
  end

  describe '#item_count_for_reservation' do
    let(:max_items) { 5 }
    let(:reservation) { create :reservation, max_items: max_items }

    context 'when item limit is not yet reached' do
      it 'allows to create item' do
        expect { create :item, reservation: reservation }.not_to raise_error
      end
    end

    context 'when item limit has been reached' do
      let!(:existing_items) { create_list :item, max_items, reservation: reservation }

      it 'does not allow to create additional items' do
        expect do
          create :item, reservation: reservation
        end.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  context 'with category#gender' do
    subject(:item) { build :item, category: category }

    let(:category) { create :category, gender: true }

    it { is_expected.not_to be_valid }
    its(:gender?) { is_expected.to eq false }

    context 'with gender set to female' do
      subject(:item) { build :item, category: category, gender: :female }

      it { is_expected.to be_valid }
      its(:female?) { is_expected.to eq true }

      its(:gender?) { is_expected.to eq true }
    end
  end
end
