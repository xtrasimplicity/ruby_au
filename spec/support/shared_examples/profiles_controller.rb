shared_examples 'an authorized request to view a profile' do |user_who_owns_profile|
  it 'responds with success' do
    expect(response).to be_success
  end

  it 'renders the show template' do
    expect(response).to render_template 'show'
  end

  it 'renders the target user\'s profile page' do
    expect(assigns(:profile)).to eq(user_who_owns_profile().profile)
    expect(assigns(:profile)).to be_valid
  end
end
