shared_examples 'an authorized request to edit a user' do |target_user|
  it 'responds with success' do
    expect(response).to be_success
  end

  it 'renders the edit template' do
    expect(response).to render_template 'edit'
  end

  it 'renders the user\'s edit page' do
    expect(assigns(:user)).to eq(target_user())
    expect(assigns(:user)).to be_valid
  end
end
