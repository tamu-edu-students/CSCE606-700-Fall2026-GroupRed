Given("{string} has a JPG profile photo with alt text {string}") do |email, alt_text|
  profile = User.find_by!(email: email).profile

  File.open(Rails.root.join("spec/fixtures/files/profile.jpg"), "rb") do |file|
    profile.update!(
      photo_alt_text: alt_text,
      photo: {
        io: file,
        filename: "profile.jpg",
        content_type: "image/jpeg"
      }
    )
  end
end
