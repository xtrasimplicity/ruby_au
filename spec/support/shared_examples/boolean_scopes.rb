shared_examples 'a boolean scope' do |model, scope_name_as_symbol, attribute, desired_value|
  before do
    @items_from_scope = model.send(scope_name_as_symbol)
  end

  it "returns all #{model.model_name.human.downcase.pluralize} with #{attribute} set to #{desired_value.to_s}" do
    # Build a hash which defines our parameters we'll pass to Model.where()
    where_parameters = Hash.new
    where_parameters[attribute] = desired_value

    expected_items = model.send(:where, where_parameters)

    expect(@items_from_scope.length).to equal(expected_items.length)

    expected_items.each do |item|
      expect(@items_from_scope).to include(item)
    end
  end

  it "does not return #{model.model_name.human.downcase.pluralize} with #{attribute} set to #{!desired_value.to_s}" do
    # Build a hash which defines our parameters we'll pass to Model.where()
    where_parameters = Hash.new
    where_parameters[attribute] = !desired_value

    items_to_not_include = model.send(:where, where_parameters)

    items_to_not_include.each do |item|
      expect(@items_from_scope).not_to include(item)
    end
  end
end
