require 'rails_helper'
require 'support/shared_examples/users_controller'

describe UsersController do
  render_views

  describe 'on GET to /users/new' do
    before { get :new }

    it "responds with success and renders the correct template" do
      expect(response).to be_success
      expect(response).to render_template 'users/new'
    end
  end

  describe 'on POST to /users/create' do

    it 'requires `joining_member` to be present in the params' do
      expect { post :create, params: {} }.to raise_error ActionController::ParameterMissing, 'param is missing or the value is empty: joining_member'
    end

    context 'valid parameters are supplied' do
      before { post :create,
               params: {
                 joining_member: { email: 'test@example.com', password: 'ThisIsAPassw0rd!', full_name: 'Barry Smith', preferred_name: 'Barry', mailing_list: true }
               }
             }

      it 'creates a valid user' do
        expect(assigns(:joining_member)).to be_valid
      end

      it 'should set the user to be a standard user (not admin)' do
        expect(assigns(:joining_member).user.is_admin?).to be false
      end

      it 'signs the user in' do
       expect(request.env[:clearance].signed_in?).to be true
      end

      it 'redirects to just_joined_path' do
        expect(response).to redirect_to just_joined_path
      end
    end

    context 'insufficient parameters are supplied' do
      before { post :create, params: { joining_member: { password: '123'} } }

      it 'renders the `users/new` template' do
        expect(response).to render_template 'users/new'
      end
    end

  end

  describe 'on GET to /users/edit' do
    setup { FactoryGirl.create(:user) }

    context 'when the user is signed in' do
      before do
        @current_user = sign_in
      end

      context 'when the target user is the same as the logged in user' do
        before do
          get :edit, params: { user_id: @current_user.id }
        end

        it_should_behave_like 'an authorized request to edit a user' do
          let(:target_user) { @current_user }
        end
      end

      context 'when the target user is different to the logged in user' do
        before(:all) do
          @other_user = FactoryGirl.create(:user)
        end

        context 'and the current user is an admin' do
          before do
            sign_out
            sign_in_as_administrator

            get :edit, params: { user_id: @other_user.id }
          end

          it_should_behave_like 'an authorized request to edit a user' do
            let(:target_user) { @other_user }
          end
        end

        context 'and the current user is not an admin' do
          before do
            get :edit, params: { user_id: @other_user.id }
          end

          it_should_behave_like 'a HTTP error was thrown', 403
        end
      end
    end

    context 'when a user is not signed in' do
      before do
        # Ensure a user exists
        FactoryGirl.create(:user)
        sign_out

        get :edit, params: { user_id: User.last.id }
      end

      it 'redirects the user to the sign_in path' do
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
