require 'rails_helper'

RSpec.describe ItemsController do
  it 'does not allow editing/updating/deleting items with labels'
  it 'does not allow viewing/editing/updating/deleting items which are not owned by the current seller'
end
