class UsersController < Clearance::UsersController
  before_action :require_login, only: :edit
  before_action :load_user, only: :edit

  def new
    @joining_member = JoiningMember.new(user: User.new)
    render "users/new"
  end

  def create
    @joining_member = JoiningMember.new(user: User.new)
    @joining_member.attributes = form_params

    if @joining_member.save
      flash[:notice] = t(".notice")
      sign_in @joining_member.user
      redirect_to just_joined_path
    else
      render "users/new"
    end
  end

  def edit
    return raise_http_error 403 unless can_edit_user?
  end

  private

  def form_params
    params.require(:joining_member).permit!.to_h
  end

  def load_user
    @user = User.find(params[:user_id])
  end

  def can_edit_user?
    @user == current_user || current_user.is_admin?
  end
end
