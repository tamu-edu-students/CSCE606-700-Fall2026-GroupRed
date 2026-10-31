class CreateCompanionMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :companion_messages do |t|
      t.references :companion, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true
      t.string :role, null: false
      t.text :body, null: false

      t.timestamps
    end

    add_index :companion_messages, %i[companion_id profile_id created_at]
  end
end
