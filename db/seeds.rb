# Demo data for development, demos and Heroku.
# Safe to run more than once: existing records are updated, not duplicated.
# Running it again also resets the demo accounts (prompts, paused, banned)
# to the state below, so it's a quick way to clean up after testing.
# Only @wingmain.test accounts are touched; real sign-ups are left alone.
#
# Admin login: admin@wingmain.test
#   - Locally the password is "password123".
#   - In production, set ADMIN_PASSWORD first: heroku config:set ADMIN_PASSWORD=... -a wingmain
# Every demo profile uses the password "password123".
#
# What's in the demo:
#   - Peter Parker: matched with Kara Zor-El (unread message from Kara) and Selina Kyle,
#     a pass on Ella Vator, and a like on Cara Mel (paused) in his swipe history
#   - Paige Turner: matched with Mike Rophone, and reported one of his messages
#   - Chad Thundercode: banned, with his resolved report
#   - Selina Kyle: has blocked Rick O'Shea
#   - Cara Mel: paused, so she's hidden from Discover
#   - Jane Doe, Justin Case and Bill Board have no photo, to show "No photo yet."

log = ->(message) { puts message unless Rails.env.test? }

admin_password = ENV["ADMIN_PASSWORD"].presence
admin_password ||= Rails.env.production? ? abort("Set ADMIN_PASSWORD before seeding production.") : "password123"

admin = User.find_or_initialize_by(email: "admin@wingmain.test")
admin.update!(password: admin_password, date_of_birth: Date.new(1990, 1, 1), role: "admin")
log.call("Admin ready: admin@wingmain.test")

demo_password = "password123"

demo_profiles = [
  { name: "Peter Parker", gender: "Man", interested_in: "Women", age: 22, range: 20..27,
    bio: "Freelance photographer. Great in a pinch, terrible at being on time. Usually hanging around somewhere in Queens.",
    first_date: "Pizza on a rooftop, then a walk across the bridge at night.",
    weekend: "Taking photos around the city, then a movie marathon with my aunt's leftovers.",
    interests: "Photography, science fairs, skateboarding, old-school video games" },
  { name: "Tony Stark", gender: "Man", interested_in: "Women", age: 38, range: 30..45,
    bio: "Engineer, inventor, occasional genius. Looking for someone who can keep up with my coffee habit.",
    first_date: "Espresso tasting, then I show you my workshop. Hard hats provided.",
    weekend: "Building something I don't need, then fixing it.",
    interests: "Engineering, cars, rock music, coffee" },
  { name: "Steve Rogers", gender: "Man", interested_in: "Women", age: 34, range: 28..40,
    bio: "Old-fashioned in the best way. Into vintage music, morning runs, and never taking shortcuts.",
    first_date: "Dinner and dancing. I've been waiting a long time to learn.",
    interests: "Running, history, swing music, drawing" },
  { name: "Stephen Strange", gender: "Man", interested_in: "Women", age: 41, range: 32..45,
    interests: "Medicine, meditation, travel, rare books",
    bio: "Surgeon turned student of the weird. I'll never be late; I've seen every possible way it could happen." },
  { name: "Barry Allen", gender: "Man", interested_in: "Everyone", age: 27, range: 22..32,
    bio: "Lab tech who runs everywhere. First date ideas: anything quick. I promise I'll slow down for you.",
    first_date: "Food truck crawl. We'll hit all of them.",
    interests: "Running, forensics, fast food, comic books" },
  { name: "John Deere", gender: "Man", interested_in: "Women", age: 33, range: 25..40,
    interests: "Farming, county fairs, country music, sunrises",
    bio: "Farmer, not a tractor. Nothing runs like me. Looking for someone who doesn't mind a little dirt." },
  { name: "Jane Doe", gender: "Woman", interested_in: "Men", age: 29, range: 25..35, photo: false,
    interests: "Mystery novels, coffee shops, puzzles",
    bio: "Very real person, I promise. Mystery novels, quiet coffee shops, and keeping a low profile." },
  { name: "Diana Prince", gender: "Woman", interested_in: "Men", age: 31, range: 27..40,
    bio: "Museum curator with a strong sense of justice. Honest to a fault; you'll always know where you stand.",
    first_date: "A museum after hours. I know the guards.",
    weekend: "Hiking, then volunteering at the animal shelter.",
    interests: "Museums, history, archery, hiking" },
  { name: "Kara Zor-El", gender: "Woman", interested_in: "Everyone", age: 24, range: 21..30,
    bio: "New in town and still getting used to the sunshine. Journalist by day. Big on hugs, bigger on breakfast.",
    first_date: "Breakfast for dinner at a 24-hour diner. Pancakes are non-negotiable.",
    weekend: "Farmers market in the morning, sunshine all afternoon, game night after.",
    interests: "Journalism, breakfast food, astronomy, board games" },
  { name: "Selina Kyle", gender: "Woman", interested_in: "Men", age: 30, range: 26..38,
    bio: "Night owl and cat person. Independent, curious, and I will probably steal your fries.",
    first_date: "Late-night jazz bar, then fries. Yours, probably.",
    weekend: "Sleeping in with my cats and exploring the city after dark.",
    interests: "Cats, jazz, night markets, gymnastics" },
  { name: "Ella Vator", gender: "Woman", interested_in: "Everyone", age: 26, range: 22..32,
    interests: "Rooftop bars, climbing gyms, puns",
    bio: "I have my ups and downs, but I always lift people up. Let's take this to the next level." },
  { name: "Barbara Gordon", gender: "Woman", interested_in: "Men", age: 28, range: 24..34,
    bio: "Librarian and part-time tech wizard. If you can't find it online, I can.",
    first_date: "Used bookstore, then trivia night. Bring your A game.",
    interests: "Libraries, coding, trivia, cycling" },
  { name: "Justin Case", gender: "Man", interested_in: "Women", age: 30, range: 25..35, photo: false,
    interests: "Camping, first aid, weather forecasts",
    bio: "Always pack an umbrella. And a spare umbrella. Looking for someone who likes being prepared." },
  { name: "Al Gorithm", gender: "Man", interested_in: "Everyone", age: 27, range: 22..33,
    first_date: "Board game cafe. Loser picks the next one.",
    interests: "Puzzles, board games, math, open source",
    bio: "I'll find your best match in O(log n). Into puzzles, board games, and well-commented code." },
  { name: "Mike Rophone", gender: "Man", interested_in: "Women", age: 32, range: 26..38,
    interests: "Karaoke, live music, podcasts",
    bio: "Karaoke regular. Will absolutely sing at you. Looking for a duet partner." },
  { name: "Rick O'Shea", gender: "Man", interested_in: "Women", age: 29, range: 24..34,
    interests: "Racquetball, pinball, puns",
    bio: "I bounce back from anything. Racquetball, pinball, and bad puns." },
  { name: "Chad Thundercode", gender: "Man", interested_in: "Women", age: 25, range: 21..30,
    interests: "Crypto, energy drinks, deploying on Fridays",
    bio: "Ships to production on Fridays. Seeking someone who appreciates a clean commit history." },
  { name: "Bill Board", gender: "Man", interested_in: "Everyone", age: 36, range: 30..42, photo: false,
    interests: "Road trips, gas station snacks, signs",
    bio: "Hard to miss. Big personality, bigger font. Into road trips and highway snacks." },
  { name: "Ty Tanic", gender: "Man", interested_in: "Women", age: 35, range: 28..40,
    interests: "Sailing, fishing, cruises",
    bio: "Great on the open water, not great with icebergs. Looking for someone who will never let go." },
  { name: "Anna Log", gender: "Woman", interested_in: "Men", age: 33, range: 28..40,
    first_date: "Record store, then a coffee shop with a real jukebox.",
    interests: "Vinyl, film photography, letter writing",
    bio: "Old-school in a digital world. Vinyl records, film cameras, and handwritten notes." },
  { name: "Paige Turner", gender: "Woman", interested_in: "Everyone", age: 27, range: 23..33,
    bio: "Bookworm with a library card I take very seriously. Tell me what you're reading.",
    first_date: "Bookstore swap: we each pick a book for the other.",
    weekend: "A long book, a longer nap, and a farmers market in between.",
    interests: "Reading, book clubs, tea, writing" },
  { name: "Sue Doku", gender: "Woman", interested_in: "Men", age: 31, range: 27..38,
    interests: "Puzzles, organizing, crosswords",
    bio: "I like everything in its proper place. Nine boxes, no repeats. Think you can solve me?" },
  { name: "Cara Mel", gender: "Woman", interested_in: "Men", age: 24, range: 21..29, paused: true,
    first_date: "A bakery crawl. Dessert first, always.",
    interests: "Baking, desserts, cooking shows",
    bio: "Sweet, but a little sticky. Baking enthusiast and a dessert-first kind of person." },
  { name: "Crystal Ball", gender: "Woman", interested_in: "Everyone", age: 37, range: 30..45,
    interests: "Tarot, astronomy, guessing games",
    bio: "I see a great first date in your future. Tarot nights, astronomy, and very good guesses." },
  { name: "Robin Banks", gender: "Woman", interested_in: "Men", age: 28, range: 24..34,
    interests: "Spreadsheets, heist movies, budgeting",
    bio: "Fully law-abiding, despite the name. Accountant who loves a good heist movie." },
  { name: "Ada Byte", gender: "Woman", interested_in: "Everyone", age: 26, range: 22..32,
    first_date: "Arcade bar. I'll let you win one game.",
    interests: "Retro computing, coding, arcade games",
    bio: "Software engineer and retro computing fan. Looking for someone who doesn't mind a little debugging." },
  { name: "Kay Oss", gender: "Non-binary", interested_in: "Everyone", age: 23, range: 21..30,
    interests: "Escape rooms, concerts, road trips",
    bio: "Spontaneous plans only. Escape rooms, last-minute concerts, and very little sleep." },
  { name: "Max Volume", gender: "Non-binary", interested_in: "Everyone", age: 29, range: 24..35,
    first_date: "Small concert, loud music, late tacos.",
    interests: "Concerts, DJing, playlists",
    bio: "Concert-goer, playlist maker, occasional DJ. Fair warning: I talk with my hands." },
  { name: "Jack Son", gender: "Non-binary", interested_in: "Everyone", age: 26, range: 22..32,
    interests: "Coding, hiking, trivia",
    bio: "Lightweight, easy to read, and I play well with others. Key: fun. Value: you." },
  { name: "Sky Lark", gender: "Non-binary", interested_in: "Everyone", age: 32, range: 26..40,
    bio: "Birdwatcher and early riser. Let's catch a sunrise and then a nap.",
    first_date: "Sunrise birdwatching, then a long breakfast.",
    weekend: "Hiking trails at dawn and a nap by noon.",
    interests: "Birdwatching, hiking, sunrises, coffee" }
]

photo_dir = Rails.root.join("db/seed_photos")
created_profiles = {}

demo_profiles.each_with_index do |person, index|
  slug = person[:name].downcase.gsub(/[^a-z ]/, "").split.join(".")
  email = "#{slug}@wingmain.test"
  birthday = (person[:age].years + (index * 11).days).ago.to_date

  user = User.find_or_initialize_by(email: email)
  user.update!(password: demo_password, date_of_birth: birthday, suspended_at: nil)

  profile = user.profile || user.build_profile
  profile.assign_attributes(
    display_name: person[:name],
    bio: person[:bio],
    gender: person[:gender],
    interested_in: person[:interested_in],
    age_min: person[:range].min,
    age_max: person[:range].max,
    ideal_first_date: person[:first_date],
    perfect_weekend: person[:weekend],
    interests: person[:interests],
    paused: person.fetch(:paused, false)
  )

  # Attach the photo only once, so reseeding doesn't upload it to S3 again
  photo_path = photo_dir.join("#{slug.tr(".", "_")}.png")
  if person.fetch(:photo, true) && !profile.photo.attached? && photo_path.exist?
    profile.photo.attach(io: File.open(photo_path), filename: photo_path.basename.to_s, content_type: "image/png")
    initials = person[:name].split.map(&:first).join
    profile.photo_alt_text = "Illustrated avatar with the initials #{initials} on a colored circle"
  end

  profile.save!
  created_profiles[person[:name]] = profile
end

# Swipes: [swiper, prospect, liked]
[
  [ "Peter Parker", "Selina Kyle", true ],
  [ "Peter Parker", "Ella Vator", false ],
  [ "Peter Parker", "Kara Zor-El", true ],
  [ "Peter Parker", "Cara Mel", true ],
  [ "Selina Kyle", "Peter Parker", true ],
  [ "Selina Kyle", "John Deere", false ],
  [ "Kara Zor-El", "Peter Parker", true ],
  [ "Paige Turner", "Mike Rophone", true ],
  [ "Mike Rophone", "Paige Turner", true ]
].each do |swiper, prospect, liked|
  Swipe.find_or_create_by!(swiper: created_profiles[swiper], prospect: created_profiles[prospect]) do |swipe|
    swipe.liked = liked
  end
end

seed_match = lambda do |profile_a, profile_b|
  ids = [ profile_a.id, profile_b.id ].sort
  Match.find_or_create_by!(profile_1_id: ids[0], profile_2_id: ids[1])
end

# Messages: [sender, body, hours ago, seen]. The last one from Kara is unread,
# so Peter sees the unread count on Conversations.
seed_conversation = lambda do |match, messages|
  messages.each do |sender, body, hours_ago, seen|
    message = match.messages.find_or_initialize_by(sender: created_profiles[sender], body: body)
    message.created_at ||= hours_ago.hours.ago
    message.seen = seen
    message.save!
  end
end

peter_selina = seed_match.call(created_profiles["Peter Parker"], created_profiles["Selina Kyle"])
seed_conversation.call(peter_selina, [
  [ "Selina Kyle", "So, photographer. Do you ever take pictures at night?", 50, true ],
  [ "Peter Parker", "All the time. The city looks better from up high.", 49, true ],
  [ "Selina Kyle", "Agreed. Rooftops are underrated.", 48, true ]
])

peter_kara = seed_match.call(created_profiles["Peter Parker"], created_profiles["Kara Zor-El"])
seed_conversation.call(peter_kara, [
  [ "Peter Parker", "Hi Kara! Breakfast for dinner is the best idea I've heard all week.", 6, true ],
  [ "Kara Zor-El", "Right? Pancakes at any hour. Where's your favorite diner?", 5, true ],
  [ "Peter Parker", "There's one in Queens that's open 24 hours. Best pancakes in the city.", 4, true ],
  [ "Kara Zor-El", "Okay, you've sold me. Saturday night?", 1, false ]
])

paige_mike = seed_match.call(created_profiles["Paige Turner"], created_profiles["Mike Rophone"])
rude_message = "You read books? Boring. Sing with me or don't bother."
seed_conversation.call(paige_mike, [
  [ "Paige Turner", "Hi Mike! What are you reading lately?", 30, true ],
  [ "Mike Rophone", rude_message, 29, true ]
])

paige = created_profiles["Paige Turner"].user
mike = created_profiles["Mike Rophone"].user
Report.find_or_create_by!(reporter: paige, reportable: mike, reason: "Reported message: \"#{rude_message}\"") do |report|
  report.status = "open"
end

# A banned account, with the report that led to it
ada = created_profiles["Ada Byte"].user
chad = created_profiles["Chad Thundercode"].user
Report.find_or_create_by!(reporter: ada, reportable: chad,
                          reason: "Sent me the same spam link five times after I passed on him.") do |report|
  report.status = "resolved"
end
chad.update!(suspended_at: 2.days.ago)

# A block, for Account → Blocked people
Block.find_or_create_by!(blocker: created_profiles["Selina Kyle"].user, blocked: created_profiles["Rick O'Shea"].user)

log.call("Seeded #{demo_profiles.size} demo profiles (password: #{demo_password})")
