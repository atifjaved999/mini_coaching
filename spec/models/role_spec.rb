require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:users) }
    it { should belong_to(:resource).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_inclusion_of(:resource_type).in_array(Rolify.resource_types).allow_nil }
  end
end
