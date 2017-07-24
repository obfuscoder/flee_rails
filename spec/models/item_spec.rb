# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item do
  subject { build(:item) }
  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:reservation) }
  it { is_expected.to validate_presence_of(:category) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:number).is_greater_than(0) }
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:reservation_id) }
  it { is_expected.to validate_uniqueness_of(:code) }
  it { is_expected.to belong_to(:category) }
  it { is_expected.to belong_to(:reservation) }

  describe '#to_s' do
    its(:to_s) { is_expected.to eq(subject.description) }

    context 'without description' do
      subject { Item.new }

      it 'calls superclass' do
        expect(subject.to_s).to eq(subject.class.superclass.instance_method(:to_s).bind(subject).call)
      end
    end
  end

  describe '#create_code' do
    let(:options) { {} }
    let(:preparations) {}
    let(:reservation) { create :reservation }
    subject { build :item, reservation: reservation }
    before do
      preparations
      subject.create_code options
    end

    its(:code) { is_expected.to eq '010010012' }
    its(:number) { is_expected.to eq 1 }

    context 'when label for other item was created already' do
      let(:preparations) { create :item_with_code, reservation: reservation }
      its(:number) { is_expected.to eq 2 }
    end

    context 'with prefix option' do
      let(:options) { { prefix: 'ABC' } }
      its(:code) { is_expected.to eq 'ABC010010012' }
    end

    context 'when code was deleted before' do
      let(:preparations) do
        subject.create_code
        subject.delete_code
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

      context 'on parent category' do
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
end
