require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = User.new(email: "test@example.com", password: "password")
    expect(user).to be_valid
  end

  it "is not valid without an email" do
    user = User.new(email: nil)
    expect(user).to_not be_valid
  end

  it "is not valid with a duplicate email" do
    User.new(email: 'test@example.com')
    user = User.new(email: 'test@example.com')
    expect(user).to_not be_valid
  end

  it "is not valid without a password" do
    user = User.new(password: nil)
    expect(user).to_not be_valid
  end

  it "is valid without a profile" do
    user = User.new(email: 'test@example.com', password: 'password')
    user.profile = nil

    expect(user).to be_valid
  end

  it "is valid with one profile" do
    user = User.new(email: 'test@example.com', password: 'password')
    user.profile = Profile.new

    expect(user).to be_valid
  end

  it "is not valid with more than one profile" do
    user = User.new
    expect { user.profiles << Profile.new }.to raise_error NoMethodError
  end
end
