require "rails_helper"

RSpec.describe "db/seeds.rb" do
  def run_seeds
    load Rails.root.join("db/seeds.rb")
  end

  def demo_profile(name)
    Profile.find_by!(display_name: name)
  end

  it "creates an admin and 30 demo profiles" do
    run_seeds
    expect(User.find_by(email: "admin@wingmain.test").role).to eq("admin")
    expect(Profile.count).to eq(30)
  end

  it "gives every demo user a companion" do
    run_seeds
    expect(User.where.missing(:companion)).to be_empty
  end

  it "can run twice without creating duplicates" do
    2.times { run_seeds }
    expect(User.count).to eq(31)
    expect(Profile.count).to eq(30)
    expect(Match.count).to eq(3)
    expect(Message.count).to eq(9)
    expect(Report.count).to eq(2)
    expect(Block.count).to eq(1)
    expect(ActiveStorage::Attachment.count).to eq(27)
  end

  it "fills in prompts and interests" do
    run_seeds
    kara = demo_profile("Kara Zor-El")
    expect(kara.ideal_first_date).to be_present
    expect(kara.perfect_weekend).to be_present
    expect(Profile.where(interests: [ nil, "" ])).to be_empty
  end

  it "gives most profiles a photo with alt text, and leaves a few without" do
    run_seeds
    peter = demo_profile("Peter Parker")
    expect(peter.photo).to be_attached
    expect(peter.photo_alt_text).to include("PP")
    expect(demo_profile("Jane Doe").photo).not_to be_attached
  end

  it "gives Peter a conversation with an unread message from Kara" do
    run_seeds
    peter = demo_profile("Peter Parker")
    kara = demo_profile("Kara Zor-El")
    unread = Match.between(peter, kara).first.messages.where(seen: false)
    expect(unread.map(&:sender)).to eq([ kara ])
  end

  it "seeds a paused profile, a banned user with a resolved report, an open message report and a block" do
    run_seeds
    expect(demo_profile("Cara Mel")).to be_paused
    chad = demo_profile("Chad Thundercode").user
    expect(chad.suspended_at).to be_present
    expect(chad.reports_against.pluck(:status)).to eq([ "resolved" ])
    expect(demo_profile("Mike Rophone").user.reports_against.open.first.reason).to start_with("Reported message:")
    expect(demo_profile("Selina Kyle").user.blocking?(demo_profile("Rick O'Shea").user)).to be(true)
  end

  it "resets the demo accounts when run again" do
    run_seeds
    demo_profile("Cara Mel").update!(paused: false)
    demo_profile("Chad Thundercode").user.update!(suspended_at: nil)
    Message.update_all(seen: true)

    run_seeds
    expect(demo_profile("Cara Mel")).to be_paused
    expect(demo_profile("Chad Thundercode").user.suspended_at).to be_present
    expect(Message.where(seen: false).count).to eq(1)
  end

  it "leaves accounts that aren't demo accounts alone" do
    real_user = User.create!(email: "someone@example.com", password: "password123", date_of_birth: 25.years.ago)
    real_user.create_profile!(display_name: "Real Person", paused: true)

    run_seeds
    expect(real_user.profile.reload.display_name).to eq("Real Person")
    expect(real_user.profile).to be_paused
  end
end
