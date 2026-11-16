require "rails_helper"

RSpec.describe CompanionService do
  let(:companion) { create(:user).companion }
  let(:profile) do
    create(
      :profile,
      ideal_first_date: "Coffee and a walk",
      perfect_weekend: "Hiking followed by a movie",
      interests: "Cooking, reading, and games"
    )
  end

  let(:expected_details) do
    [
      "Ideal first date: Coffee and a walk",
      "A perfect weekend: Hiking followed by a movie",
      "Interests: Cooking, reading, and games"
    ]
  end

  %i[ react openers profile_feedback ].each do |action|
    it "includes the answers when generating #{action}" do
      profile.update!(user: companion.user) if action == :profile_feedback

      expect(described_class).to receive(:ask).with(
        companion,
        a_string_including(*expected_details)
      ).and_return(nil)

      described_class.public_send(action, companion, profile)
    end
  end

  it "includes the answers in companion chat" do
    expect(described_class).to receive(:ask) do |received_companion, turns|
      expect(received_companion).to eq(companion)
      expect(turns.first[:content]).to include(*expected_details)
      nil
    end

    described_class.reply(companion, profile, "What should we talk about?")
  end

  it "omits unanswered prompts and interests" do
    profile.update!(
      ideal_first_date: nil,
      perfect_weekend: "",
      interests: " "
    )

    expect(described_class).to receive(:ask) do |_companion, prompt|
      expect(prompt).not_to include(
        "Ideal first date:",
        "A perfect weekend:",
        "Interests:"
      )
      nil
    end

    described_class.react(companion, profile)
  end
end
