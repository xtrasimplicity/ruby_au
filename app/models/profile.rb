class Profile < ApplicationRecord
  belongs_to :user

  def is_public?
    self.is_public
  end
end
