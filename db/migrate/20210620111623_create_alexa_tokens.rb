class CreateAlexaTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :alexa_tokens do |t|
      t.integer :user_id, null: false

      t.string :authentication, null: false
      t.string :access
      t.string :refresh

      t.timestamps
    end

    add_index :alexa_tokens, :user_id, unique: true
    add_index :alexa_tokens, :authentication, unique: true
  end
end
