class AddUsernameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string
    add_column :users, :public_profile, :boolean, default: false
    add_index :users, :username, unique: true
  end
end
