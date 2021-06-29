class ChangeWaterAtDefaultValue < ActiveRecord::Migration[6.0]
  def change
    change_column :devices, :water_at, :integer, default: 20
  end
end
