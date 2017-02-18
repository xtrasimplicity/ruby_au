class ProfilesController < ApplicationController
  before_action :require_login
  before_action :load_profile, only: [:show]

 def show
   unless @profile_owner == current_user
     unless @profile.is_public
       render 'errors/403', status: 403
     end
   end
 end

 private

 def load_profile
   @profile_owner = User.find(params[:user_id])
   @profile = @profile_owner.profile
 end
end
