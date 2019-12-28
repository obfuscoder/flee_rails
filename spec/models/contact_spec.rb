require 'rails_helper'

RSpec.describe Contact do
  subject(:contact) { build :contact }

  it { is_expected.to be_valid }
end
