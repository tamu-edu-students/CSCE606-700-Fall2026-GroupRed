class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :display_name, null: false
      t.text :bio
      t.string :gender
      t.string :interested_in
      t.integer :age_min
      t.integer :age_max

      t.timestamps
    end
  end
end
