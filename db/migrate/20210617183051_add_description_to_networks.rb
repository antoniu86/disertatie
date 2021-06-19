class AddDescriptionToNetworks < ActiveRecord::Migration[6.0]
  def change
    add_column :networks, :description, :text
  end
end
