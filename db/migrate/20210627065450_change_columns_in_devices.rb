class ChangeColumnsInDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :soil, :integer, default: 0
    add_column :devices, :duration, :integer, null: false, default: 5
    remove_column :devices, :timing
  end
end
