class User < ApplicationRecord
  include Clearance::User
  has_one :profile, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  def is_admin?
    self.is_admin
  end

end
