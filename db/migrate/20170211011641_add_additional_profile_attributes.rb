class AddAdditionalProfileAttributes < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :description, :text
    add_column :profiles, :twitter, :string
    add_column :profiles, :website, :string
    add_column :profiles, :is_public, :bool, default: false, null: false
    add_column :profiles, :location, :string
  end
end
