# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateChecksum do
  subject { described_class.new.call number }

  {
    nil => 0,
    '' => 0,
    '1' => 6, # 49 => 4+9 = 13 % 10 => 3 * 2 = 6
    '257' => 9, # (50, 53, 55) => (5*2, 8, 0*2) => (1 + 8 + 0) => 9
    'cC3' => 3, # (99, 67, 51) => (8*2, 3, 6*2) => (7 + 3 + 3) => 3
    'zZ' => 4, # (122, 90) => (5, 9*2) => (5 + 9) => 4
    1 => 6,
    257 => 9
  }.each do |number, expected_result|
    context "with input #{number.inspect}" do
      let(:number) { number }

      it { is_expected.to eq expected_result }
    end
  end
end
