class AddWeeklyRecapToCompanions < ActiveRecord::Migration[8.1]
  def change
    add_column :companions, :weekly_recap, :text
    add_column :companions, :weekly_recap_generated_at, :datetime
  end
end
