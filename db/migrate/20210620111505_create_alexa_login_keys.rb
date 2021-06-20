class CreateAlexaLoginKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :alexa_login_keys do |t|
      t.integer :user_id, null: false

      t.string :login_key, null: false, limit: 10
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :alexa_login_keys, :user_id, unique: true
    add_index :alexa_login_keys, :login_key, unique: true
  end
end
