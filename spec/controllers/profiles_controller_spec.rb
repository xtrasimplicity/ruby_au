require 'rails_helper'

describe ProfilesController do
  render_views

  describe 'on GET to /profiles/show' do

    context 'when a user is signed in' do
      before  { @current_user = sign_in }

      context 'when the user is attempting to view their own page' do
        before { get :show, params: { user_id: @current_user.id } }

        it 'responds with success and renders the show template' do
          expect(response).to be_success
          expect(response).to render_template 'show'
        end

        it 'shows the correct user\'s data' do
         expect(assigns(:profile)).to eq(@current_user.profile)
         expect(assigns(:profile)).to be_valid
        end
      end

      context 'when the user is attempting to view someone else\'s page' do
        before { @target_user = FactoryGirl.create(:user) }

        context 'when the other user\'s profile is set to public' do
          before do
            @target_user.profile.update_attribute(:is_public, true)

            get :show, params: { user_id: @target_user.id }
          end

          it 'responds with success and renders their profile page' do
            expect(response).to be_success
            expect(response).to render_template 'show'
            expect(assigns(:profile)).to eq(@target_user.profile)
          end
        end

        context 'when the other user\'s profile is NOT set to public' do
          before do
            @target_user.profile.update_attribute(:is_public, false)

            get :show, params: { user_id: @target_user.id }
          end

          it 'responds with a 403 error' do
            expect(response).to have_http_status 403
          end

          it 'renders a 403 page' do
            expect(response).to render_template 'errors/403'
          end
        end
      end
    end

    context 'when a user is not signed in' do
      before do
        target_user = FactoryGirl.create(:user)
        sign_out
        get :show, params: { user_id: target_user.id }
      end

      it 'redirects to the login page' do
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
