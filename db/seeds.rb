# Demo data for development, demos and Heroku.
# Safe to run more than once: existing records are updated, not duplicated.
#
# Admin login: admin@wingmain.test
#   - Locally the password is "password123".
#   - In production, set ADMIN_PASSWORD first: heroku config:set ADMIN_PASSWORD=... -a wingmain
# Every demo profile uses the password "password123".

log = ->(message) { puts message unless Rails.env.test? }

admin_password = ENV["ADMIN_PASSWORD"].presence
admin_password ||= Rails.env.production? ? abort("Set ADMIN_PASSWORD before seeding production.") : "password123"

admin = User.find_or_initialize_by(email: "admin@wingmain.test")
admin.update!(password: admin_password, date_of_birth: Date.new(1990, 1, 1), role: "admin")
log.call("Admin ready: admin@wingmain.test")

demo_password = "password123"

demo_profiles = [
  { name: "Peter Parker", gender: "Man", interested_in: "Women", age: 22, range: 20..27,
    bio: "Freelance photographer. Great in a pinch, terrible at being on time. Usually hanging around somewhere in Queens." },
  { name: "Tony Stark", gender: "Man", interested_in: "Women", age: 38, range: 30..45,
    bio: "Engineer, inventor, occasional genius. Looking for someone who can keep up with my coffee habit." },
  { name: "Steve Rogers", gender: "Man", interested_in: "Women", age: 34, range: 28..40,
    bio: "Old-fashioned in the best way. Into vintage music, morning runs, and never taking shortcuts." },
  { name: "Stephen Strange", gender: "Man", interested_in: "Women", age: 41, range: 32..45,
    bio: "Surgeon turned student of the weird. I'll never be late; I've seen every possible way it could happen." },
  { name: "Barry Allen", gender: "Man", interested_in: "Everyone", age: 27, range: 22..32,
    bio: "Lab tech who runs everywhere. First date ideas: anything quick. I promise I'll slow down for you." },
  { name: "John Deere", gender: "Man", interested_in: "Women", age: 33, range: 25..40,
    bio: "Farmer, not a tractor. Nothing runs like me. Looking for someone who doesn't mind a little dirt." },
  { name: "Jane Doe", gender: "Woman", interested_in: "Men", age: 29, range: 25..35,
    bio: "Very real person, I promise. Mystery novels, quiet coffee shops, and keeping a low profile." },
  { name: "Diana Prince", gender: "Woman", interested_in: "Men", age: 31, range: 27..40,
    bio: "Museum curator with a strong sense of justice. Honest to a fault; you'll always know where you stand." },
  { name: "Kara Zor-El", gender: "Woman", interested_in: "Everyone", age: 24, range: 21..30,
    bio: "New in town and still getting used to the sunshine. Journalist by day. Big on hugs, bigger on breakfast." },
  { name: "Selina Kyle", gender: "Woman", interested_in: "Men", age: 30, range: 26..38,
    bio: "Night owl and cat person. Independent, curious, and I will probably steal your fries." },
  { name: "Ella Vator", gender: "Woman", interested_in: "Everyone", age: 26, range: 22..32,
    bio: "I have my ups and downs, but I always lift people up. Let's take this to the next level." },
  { name: "Barbara Gordon", gender: "Woman", interested_in: "Men", age: 28, range: 24..34,
    bio: "Librarian and part-time tech wizard. If you can't find it online, I can." },
  { name: "Justin Case", gender: "Man", interested_in: "Women", age: 30, range: 25..35,
    bio: "Always pack an umbrella. And a spare umbrella. Looking for someone who likes being prepared." },
  { name: "Al Gorithm", gender: "Man", interested_in: "Everyone", age: 27, range: 22..33,
    bio: "I'll find your best match in O(log n). Into puzzles, board games, and well-commented code." },
  { name: "Mike Rophone", gender: "Man", interested_in: "Women", age: 32, range: 26..38,
    bio: "Karaoke regular. Will absolutely sing at you. Looking for a duet partner." },
  { name: "Rick O'Shea", gender: "Man", interested_in: "Women", age: 29, range: 24..34,
    bio: "I bounce back from anything. Racquetball, pinball, and bad puns." },
  { name: "Chad Thundercode", gender: "Man", interested_in: "Women", age: 25, range: 21..30,
    bio: "Ships to production on Fridays. Seeking someone who appreciates a clean commit history." },
  { name: "Bill Board", gender: "Man", interested_in: "Everyone", age: 36, range: 30..42,
    bio: "Hard to miss. Big personality, bigger font. Into road trips and highway snacks." },
  { name: "Ty Tanic", gender: "Man", interested_in: "Women", age: 35, range: 28..40,
    bio: "Great on the open water, not great with icebergs. Looking for someone who will never let go." },
  { name: "Anna Log", gender: "Woman", interested_in: "Men", age: 33, range: 28..40,
    bio: "Old-school in a digital world. Vinyl records, film cameras, and handwritten notes." },
  { name: "Paige Turner", gender: "Woman", interested_in: "Everyone", age: 27, range: 23..33,
    bio: "Bookworm with a library card I take very seriously. Tell me what you're reading." },
  { name: "Sue Doku", gender: "Woman", interested_in: "Men", age: 31, range: 27..38,
    bio: "I like everything in its proper place. Nine boxes, no repeats. Think you can solve me?" },
  { name: "Cara Mel", gender: "Woman", interested_in: "Men", age: 24, range: 21..29,
    bio: "Sweet, but a little sticky. Baking enthusiast and a dessert-first kind of person." },
  { name: "Crystal Ball", gender: "Woman", interested_in: "Everyone", age: 37, range: 30..45,
    bio: "I see a great first date in your future. Tarot nights, astronomy, and very good guesses." },
  { name: "Robin Banks", gender: "Woman", interested_in: "Men", age: 28, range: 24..34,
    bio: "Fully law-abiding, despite the name. Accountant who loves a good heist movie." },
  { name: "Ada Byte", gender: "Woman", interested_in: "Everyone", age: 26, range: 22..32,
    bio: "Software engineer and retro computing fan. Looking for someone who doesn't mind a little debugging." },
  { name: "Kay Oss", gender: "Non-binary", interested_in: "Everyone", age: 23, range: 21..30,
    bio: "Spontaneous plans only. Escape rooms, last-minute concerts, and very little sleep." },
  { name: "Max Volume", gender: "Non-binary", interested_in: "Everyone", age: 29, range: 24..35,
    bio: "Concert-goer, playlist maker, occasional DJ. Fair warning: I talk with my hands." },
  { name: "Jack Son", gender: "Non-binary", interested_in: "Everyone", age: 26, range: 22..32,
    bio: "Lightweight, easy to read, and I play well with others. Key: fun. Value: you." },
  { name: "Sky Lark", gender: "Non-binary", interested_in: "Everyone", age: 32, range: 26..40,
    bio: "Birdwatcher and early riser. Let's catch a sunrise and then a nap." }
]

demo_profiles.each_with_index do |person, index|
  email = "#{person[:name].downcase.gsub(/[^a-z ]/, "").split.join(".")}@wingmain.test"
  birthday = (person[:age].years + (index * 11).days).ago.to_date

  user = User.find_or_initialize_by(email: email)
  user.update!(password: demo_password, date_of_birth: birthday)

  profile = user.profile || user.build_profile
  profile.update!(
    display_name: person[:name],
    bio: person[:bio],
    gender: person[:gender],
    interested_in: person[:interested_in],
    age_min: person[:range].min,
    age_max: person[:range].max
  )
end

log.call("Seeded #{demo_profiles.size} demo profiles (password: #{demo_password})")
