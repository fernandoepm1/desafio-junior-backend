require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user)}

  describe 'creation' do
    it 'is valid with valid atributes' do
      expect(user).to be_valid
    end

    it 'is invalid with empty atributes' do
      user = User.new
      expect(user).to_not be_valid
    end

    it 'is invalid with invalid email' do
      user = build(:user,:invalid_email)
      expect(user).to_not be_valid
    end

    it 'is invalid with duplicated email' do
      user2 = build(:user)
      user2.email = user.email
      expect(user2).to_not be_valid
    end

  end

  describe 'shoulda matchers' do
    context 'associations' do
      it { should have_many(:messages)}
    end

    context 'validations' do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:email) }
    end
  end
end
