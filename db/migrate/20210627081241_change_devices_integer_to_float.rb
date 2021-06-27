class ChangeDevicesIntegerToFloat < ActiveRecord::Migration[6.0]
  def change
    change_column :devices, :temperature, :float, null: false, default: 0
    change_column :devices, :humidity, :float, null: false, default: 0
  end
end
