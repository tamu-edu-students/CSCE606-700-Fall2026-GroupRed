class Match < ApplicationRecord
  belongs_to :profile_id_1, class_name: "Profile"
  belongs_to :profile_id_2, class_name: "Profile"
end
