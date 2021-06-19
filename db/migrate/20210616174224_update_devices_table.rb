class UpdateDevicesTable < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :network_id, :integer
    add_index :devices, :network_id
  end
end
