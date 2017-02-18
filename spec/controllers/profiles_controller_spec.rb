require 'rails_helper'
require 'support/shared_examples/profiles_controller'

describe ProfilesController do
  render_views

  describe 'on GET to /profiles/show' do

    context 'when a user is signed in' do
      before  { @current_user = sign_in }

      context 'when the user is attempting to view their own page' do
        before { get :show, params: { user_id: @current_user.id } }

        it_should_behave_like 'an authorized request to view a profile' do
          let(:user_who_owns_profile) { @current_user }
        end
      end

      context 'when the user is attempting to view someone else\'s page' do
        before { @target_user = FactoryGirl.create(:user) }

        describe 'when the other user\'s profile is set to public' do
          before do
            @target_user.profile.update_attribute(:is_public, true)

            get :show, params: { user_id: @target_user.id }
          end

          it_should_behave_like 'an authorized request to view a profile' do
            let(:user_who_owns_profile) { @target_user }
          end
        end

        context 'when the other user\'s profile is NOT set to public' do
          before do
            @target_user.profile.update_attribute(:is_public, false)
          end

          context 'when the current user is an administrator' do
            before do
              sign_out
              sign_in_as_administrator

              get :show, params: { user_id: @target_user.id }
            end

            it_should_behave_like 'an authorized request to view a profile' do
              let(:user_who_owns_profile) { @target_user }
            end
          end

          context 'when the current user is not an administrator' do
            before { get :show, params: { user_id: @target_user.id } }

            it 'responds with a 403 error' do
              expect(response).to have_http_status 403
            end

            it 'renders a 403 page' do
              expect(response).to render_template 'errors/403'
            end
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
