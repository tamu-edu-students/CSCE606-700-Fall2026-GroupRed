class CreateCompanions < ActiveRecord::Migration[8.1]
  def change
    create_table :companions do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :name, null: false, default: "Wingman"
      t.string :personality, null: false, default: "playful and honest, like a close friend"
      t.text :memory_summary
      t.text :greeting

      t.timestamps
    end
  end
end
