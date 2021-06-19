class AddWaterAtToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :water_at, :integer, default: 0
  end
end
