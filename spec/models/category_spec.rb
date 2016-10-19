require 'rails_helper'

RSpec.describe Category do
  subject { build :category }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to have_many(:items) }

  describe '#to_s' do
    its(:to_s) { is_expected.to eq subject.name }

    context 'without name' do
      subject { Category.new }

      it 'calls superclass' do
        expect(subject.to_s).to eq(subject.class.superclass.instance_method(:to_s).bind(subject).call)
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
end
