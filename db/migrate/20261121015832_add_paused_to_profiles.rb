class AddPausedToProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :profiles, :paused, :boolean, null: false, default: false 
  end
end
