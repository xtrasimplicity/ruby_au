class Profile < ApplicationRecord
  belongs_to :user

  scope :public_profiles, -> { where is_public: true }
  scope :private_profiles,-> { where is_public: false }

  def is_public?
    self.is_public
  end
end
