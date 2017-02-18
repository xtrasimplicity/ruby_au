require 'rails_helper'
require 'support/shared_examples/boolean_scopes'

RSpec.describe Profile, type: :model do
  it "is valid with valid attributes" do
    profile = Profile.new(user: User.new)
    expect(profile).to be_valid
  end

  it "is not valid without a user" do
    profile = Profile.new(user_id: nil)
    expect(profile).to_not be_valid
  end

  context 'scopes' do
    before do
      # Create 10 users, 5 with public profiles, 5 with private profiles.
      5.times do
        user_with_private_profile = FactoryGirl.create(:user)
        user_with_private_profile.profile.update_attribute(:is_public, false)

        user_with_public_profile = FactoryGirl.create(:user)
        user_with_public_profile.profile.update_attribute(:is_public, true)
      end
    end

    describe 'public_profiles' do
      it_should_behave_like 'a boolean scope', Profile, :public_profiles, :is_public, true
    end

    describe 'private_profiles' do
      it_should_behave_like 'a boolean scope', Profile, :private_profiles, :is_public, false
    end
  end
end
