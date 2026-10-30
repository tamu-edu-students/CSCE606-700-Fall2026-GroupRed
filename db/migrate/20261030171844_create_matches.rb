class CreateMatches < ActiveRecord::Migration[8.1]
  def change
    create_table :matches do |t|
      t.references :profile_id_1, null: false, foreign_key: {to_table: :profiles}
      t.references :profile_id_2, null: false, foreign_key: {to_table: :profiles}

      t.timestamps
    end
  end
end
