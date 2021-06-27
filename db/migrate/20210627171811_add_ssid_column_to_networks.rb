class AddSsidColumnToNetworks < ActiveRecord::Migration[6.0]
  def change
    add_column :networks, :ssid, :string, null: false, limit: 20
    change_column :networks, :name, :string, null: false, limit: 255
  end
end
