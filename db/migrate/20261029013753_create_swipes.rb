class CreateSwipes < ActiveRecord::Migration[7.1]
  def change
    create_table :swipes do |t|
      t.references :swiper,
                   null: false,
                   foreign_key: { to_table: :profiles }

      t.references :prospect,
                   null: false,
                   foreign_key: { to_table: :profiles }

      t.boolean :liked, null: false

      t.timestamps
    end

    add_index :swipes, [ :swiper_id, :prospect_id ], unique: true

    add_check_constraint :swipes,
                         "swiper_id != prospect_id",
                         name: "swipes_cannot_target_self"
  end
end
