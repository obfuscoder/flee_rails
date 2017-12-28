# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category do
  subject(:category) { build :category }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to belong_to :client }
  it { is_expected.to have_many :items  }
  it { is_expected.to belong_to :parent }
  it { is_expected.to have_many :children }

  describe '#to_s' do
    its(:to_s) { is_expected.to eq subject.name }

    context 'without name' do
      subject { Category.new }

      it 'calls superclass' do
        expect(subject.to_s).to eq(subject.class.superclass.instance_method(:to_s).bind(subject).call)
      end
    end
  end

  describe '#descendants' do
    subject(:action) { category.descendants }
    it { is_expected.to eq [] }
    context 'with child' do
      let(:child) { build :category }
      before { category.children << child }
      it { is_expected.to include child }
    end
    context 'with grand child' do
      let(:grand_child) { build :category }
      let(:child) { build :category, children: [grand_child] }
      before { category.children << child }
      it { is_expected.to include child }
      it { is_expected.to include grand_child }
    end
  end

  describe '#possible_parents' do
    subject(:action) { category.possible_parents }
    it { is_expected.to be_empty }
    context 'when category is persisted' do
      let(:category) { create :category }
      it { is_expected.to be_empty }
      context 'with other category' do
        let(:other_category) { create :category }
        it { is_expected.to include other_category }
        context 'with child' do
          let(:child) { create :category }
          before { category.children << child }
          it { is_expected.not_to include child }
        end
      end
    end
  end

  describe '#destroy' do
    before { subject.save }
    it 'does not delete record' do
      expect { subject.destroy }.not_to change { Category.with_deleted.count }
    end

    it 'marks record as deleted' do
      expect { subject.destroy }.to change { subject.deleted_at }.from(nil)
    end
  end

  describe '#self_and_parents' do
    subject { category.self_and_parents }
    it { is_expected.to have(1).element }
    context 'when category has parent' do
      let(:category) { create :category, parent: parent }
      let(:parent) { create :category }
      it { is_expected.to have(2).elements }
      it { is_expected.to include category }
      it { is_expected.to include parent }
    end
  end

  describe '#most_limited_category' do
    let(:category) { create :category }
    subject { category.most_limited_category }
    it { is_expected.to eq nil }
    context 'when category has item limit' do
      let(:category) { create :category, max_items_per_seller: 3 }
      it { is_expected.to eq category }
    end
    context 'with parent category having item limit' do
      let(:category) { create :category, parent: parent }
      let(:parent) { create :category, max_items_per_seller: 4 }
      it { is_expected.to eq parent }
      context 'when own limit is higher' do
        let(:category) { create :category, parent: parent, max_items_per_seller: 6 }
        it { is_expected.to eq parent }
      end
      context 'when own limit is lower' do
        let(:category) { create :category, parent: parent, max_items_per_seller: 3 }
        it { is_expected.to eq category }
      end
    end
  end
end
