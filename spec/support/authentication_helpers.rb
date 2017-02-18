def sign_in_as_administrator
  user = sign_in
  user.update_attribute(:is_admin, true)

  user
end
