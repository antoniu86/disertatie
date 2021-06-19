class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.string    :name, null: false, default: ""
      t.text      :description
      t.string    :code
      t.integer   :status, null: false, default: 0

      t.integer   :user_id, null: false

      t.timestamps null: false
    end

    add_index :devices, :user_id
  end
end
