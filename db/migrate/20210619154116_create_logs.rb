class CreateLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :logs do |t|
      t.integer   :user_id, null: false
      t.integer   :device_id, null: false

      t.text      :content

      t.timestamps
    end

    add_index :logs, :user_id
    add_index :logs, :device_id
  end
end
