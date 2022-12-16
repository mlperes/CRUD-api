require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  it { should validate_length_of(:name).is_at_least(10) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:cpf) }
  it { should validate_uniqueness_of(:cpf) }
end