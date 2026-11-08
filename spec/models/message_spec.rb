require "rails_helper"

RSpec.describe Message, type: :model do
  let(:match) { create(:match) }

  it { is_expected.to belong_to(:match) }
  it { is_expected.to belong_to(:sender).class_name("Profile") }

  it "is valid when sent by someone in the match" do
    expect(build(:message, match: match, sender: match.profile_2)).to be_valid
  end

  it "strips surrounding whitespace from the body" do
    expect(build(:message, body: "  hello  ").body).to eq("hello")
  end

  it "requires a body" do
    message = build(:message, body: "   ")

    expect(message).not_to be_valid
    expect(message.errors.full_messages).to include("Message can't be blank")
  end

  it "limits the body length" do
    expect(build(:message, body: "a" * (Message::MAX_LENGTH + 1))).not_to be_valid
  end

  it "rejects a sender who isn't part of the match" do
    message = build(:message, match: match, sender: create(:profile))

    expect(message).not_to be_valid
    expect(message.errors[:sender]).to include("isn't part of this match")
  end

  describe ".oldest_first" do
    it "orders messages from oldest to newest" do
      newer = create(:message, match: match, created_at: 1.minute.ago)
      older = create(:message, match: match, created_at: 1.hour.ago)

      expect(match.messages.oldest_first).to eq([ older, newer ])
    end
  end
end

