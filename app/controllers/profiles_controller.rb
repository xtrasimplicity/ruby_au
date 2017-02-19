class ProfilesController < ApplicationController
  before_action :require_login
  before_action :load_profile, only: [:show]

 def index
   if current_user.is_admin?
     @profiles = Profile.all
   else
     @profiles = Profile.public_profiles
   end

 end

 def show
   return raise_http_error 403 unless is_current_user_authorized_to_view_profile?
 end

 private

 def load_profile
   @profile_owner = User.find(params[:user_id])
   @profile = @profile_owner.profile
 end

 def is_current_user_authorized_to_view_profile?
   @profile_owner == current_user || @profile.is_public || current_user.is_admin?
 end
end
