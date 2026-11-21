class AddSeenToMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :seen, :boolean, default: false, null: false
    up_only { execute "UPDATE messages SET seen = TRUE" }
  end
end
