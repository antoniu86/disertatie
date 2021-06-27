class AddTimingColumnInDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :timing, :integer, null: false, default: 4
  end
end
