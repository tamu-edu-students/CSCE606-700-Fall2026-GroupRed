require "rails_helper"

RSpec.describe "db/seeds.rb" do
  def run_seeds
    load Rails.root.join("db/seeds.rb")
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
  end
end
