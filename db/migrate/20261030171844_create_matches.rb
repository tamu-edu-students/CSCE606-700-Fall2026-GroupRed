class CreateMatches < ActiveRecord::Migration[8.1]
  def change
    create_table :matches do |t|
      t.references :profile_1, null: false, foreign_key: { to_table: :profiles }
      t.references :profile_2, null: false, foreign_key: { to_table: :profiles }

      t.timestamps
    end
    add_index :matches, [ :profile_1_id, :profile_2_id ], unique: true
  end
end
