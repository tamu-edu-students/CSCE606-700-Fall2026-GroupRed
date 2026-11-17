require "rails_helper"

RSpec.describe CompanionService do
  let(:companion) { create(:user).companion }
  let(:profile) do
    create(:profile, user: companion.user, display_name: "Sam")
  end
  let(:other_profile) do
    create(:profile, display_name: "Taylor", bio: "I bake bread.")
  end
  let(:our_match) do
    create(:match, profile_1: profile, profile_2: other_profile)
  end

  describe ".suggest_reply" do
    it "uses the other profile and this conversation in chronological order" do
      create(:message, match: our_match, sender: profile,
             body: "Saturday works!", created_at: 1.minute.ago)
      create(:message, match: our_match, sender: other_profile,
             body: "Coffee on Saturday?", created_at: 2.minutes.ago)
      create(:message, body: "Message from a different match")

      conversation = [
        { speaker: "Match", text: "Coffee on Saturday?" },
        { speaker: "Sender", text: "Saturday works!" }
      ]

      expect(described_class).to receive(:ask) do |sent_companion, prompt|
        expect(sent_companion).to eq(companion)
        expect(prompt).to include("Taylor", "I bake bread.", conversation.to_json)
        expect(prompt).not_to include(
          "Message from a different match",
          companion.user.email,
          other_profile.user.email
        )
        "How about 10 a.m.?"
      end

      expect(
        described_class.suggest_reply(companion, our_match, profile)
      ).to eq("How about 10 a.m.?")
    end

    it "uses only the newest 10 messages and orders tied timestamps by ID" do
      timestamp = Time.current.change(usec: 0)

      12.times do |index|
        create(:message, match: our_match, sender: profile,
               body: "History entry #{index}.", created_at: timestamp)
      end

      conversation = (2..11).map do |index|
        { speaker: "Sender", text: "History entry #{index}." }
      end

      expect(described_class).to receive(:ask) do |_companion, prompt|
        expect(prompt).to include(conversation.to_json)
        expect(prompt).not_to include("History entry 0.", "History entry 1.")
        "What do you think?"
      end

      described_class.suggest_reply(companion, our_match, profile)
    end

    it "uses the correct perspective for the second person in the match" do
      create(:message, match: our_match, sender: profile,
             body: "Want to get coffee?", created_at: 2.minutes.ago)
      create(:message, match: our_match, sender: other_profile,
             body: "Yes!", created_at: 1.minute.ago)

      conversation = [
        { speaker: "Match", text: "Want to get coffee?" },
        { speaker: "Sender", text: "Yes!" }
      ]

      expect(described_class).to receive(:ask) do |sent_companion, prompt|
        expect(sent_companion).to eq(other_profile.user.companion)
        expect(prompt).to include("Name: Sam", conversation.to_json)
        "What time works for you?"
      end

      described_class.suggest_reply(
        other_profile.user.companion, our_match, other_profile
      )
    end

    it "can suggest an opening message when the conversation is empty" do
      expect(described_class).to receive(:ask) do |_companion, prompt|
        expect(prompt).to include(
          "Recent messages (oldest first):\n[]",
          "suggest an opening message"
        )
        "What do you like baking?"
      end

      expect(
        described_class.suggest_reply(companion, our_match, profile)
      ).to eq("What do you like baking?")
    end

    it "trims the suggestion and logs the request without sending a message" do
      allow(described_class).to receive(:ask).and_return(
        "  Saturday works for me! \n"
      )
      suggestion = nil

      expect {
        suggestion = described_class.suggest_reply(
          companion, our_match, profile
        )
      }.not_to change(Message, :count)

      expect(suggestion).to eq("Saturday works for me!")
      expect(
        companion.companion_messages.about(other_profile).pluck(:role, :body)
      ).to eq(
        [
          [ "user", described_class::REPLY_SUGGESTION_REQUEST ],
          [ "companion", "Saturday works for me!" ]
        ]
      )
    end

    {
      "unavailable" => nil,
      "empty" => "",
      "only whitespace" => " \n\t "
    }.each do |description, response|
      it "returns nil and saves nothing when the AI response is #{description}" do
        allow(described_class).to receive(:ask).and_return(response)

        expect(
          described_class.suggest_reply(companion, our_match, profile)
        ).to be_nil
        expect(companion.companion_messages).to be_empty
      end
    end

    it "limits the draft and saved companion message to their allowed lengths" do
      allow(described_class).to receive(:ask).and_return(
        "a" * (Message::MAX_LENGTH + 100)
      )

      suggestion = described_class.suggest_reply(
        companion, our_match, profile
      )
      saved_reply = companion.companion_messages.find_by!(
        profile: other_profile, role: "companion"
      )

      expect(suggestion.length).to eq(Message::MAX_LENGTH)
      expect(saved_reply.body.length).to eq(500)
    end
  end
end
