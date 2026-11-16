class AddPromptsAndInterestsToProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :profiles, :ideal_first_date, :text
    add_column :profiles, :perfect_weekend, :text
    add_column :profiles, :interests, :text
  end
end
