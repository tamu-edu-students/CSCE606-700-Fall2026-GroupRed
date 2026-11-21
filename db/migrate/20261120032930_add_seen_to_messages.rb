class AddSeenToMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :seen, :boolean, default: false, null: false
  end
end
