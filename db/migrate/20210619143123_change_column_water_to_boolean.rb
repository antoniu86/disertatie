class ChangeColumnWaterToBoolean < ActiveRecord::Migration[6.0]
  def change
    change_column :devices, :water, :boolean, default: false
  end
end
