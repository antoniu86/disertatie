class AddColumnsToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :humidity, :integer, default: 0
    add_column :devices, :level, :integer, default: 0
    add_column :devices, :temperature, :integer, default: 0
    add_column :devices, :water, :integer, default: 0
    add_column :devices, :watered_at, :datetime
  end
end
