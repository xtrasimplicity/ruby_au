shared_examples 'an authorized request to edit a user' do |target_user|
  it 'responds with success' do
    expect(response).to be_success
  end

  it 'renders the edit template' do
    expect(response).to render_template 'edit'
  end

  it 'renders the user\'s edit page' do
    expect(assigns(:joining_member)).to eq(target_user())
    expect(assigns(:joining_member)).to be_valid
  end
end

shared_examples 'an authorized request to update a user' do |target_user|
  it 'responds with success' do
    expect(response).to be_success
  end

  it 'updates the user' do
    user = target_user()
   
    # Get the user from the database again, to see whether it has changed
    # NOTE: The instance of target_user passed to this shared example would NOT have changed
    # since the Users controller updated it. I.e. it hasn't been reloaded
    updated_user = User.find(user.id)

    expect(updated_user).to_not equal(user)
  end
end

shared_examples 'an unauthorized request to update a user' do |target_user|
  it_should_behave_like 'a HTTP error was thrown', 403

  it 'does not update the user' do
    user = target_user()

    updated_user = User.find(user.id)

    expect(updated_user).to eq(user)
  end
end
