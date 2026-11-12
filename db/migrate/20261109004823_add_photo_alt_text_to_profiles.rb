class AddPhotoAltTextToProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :profiles, :photo_alt_text, :string
  end
end
