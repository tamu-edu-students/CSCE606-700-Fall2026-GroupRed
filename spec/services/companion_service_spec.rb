require "rails_helper"

RSpec.describe CompanionService do
  let(:companion) { create(:user).companion }

  describe ".greet" do
    it "returns the saved greeting without calling the AI" do
      companion.update!(greeting: "Hi again!")
      expect(described_class).not_to receive(:ask)
      expect(described_class.greet(companion)).to eq("Hi again!")
    end

    it "saves and returns a new greeting" do
      allow(described_class).to receive(:ask).and_return("Hey there!")
      expect(described_class.greet(companion)).to eq("Hey there!")
      expect(companion.reload.greeting).to eq("Hey there!")
    end

    it "returns the fallback and saves nothing when the AI is unavailable" do
      allow(described_class).to receive(:ask).and_return(nil)
      expect(described_class.greet(companion)).to eq(CompanionService::FALLBACK)
      expect(companion.reload.greeting).to be_nil
    end
  end

  describe ".react" do
    let(:profile) do
      create(:profile, display_name: "Taylor", bio: "I enjoy traveling.", gender: "Woman",
             user: create(:user, email: "taylor@example.com", date_of_birth: Date.new(2000, 1, 1)))
    end

    it "saves and returns a new reaction" do
      allow(described_class).to receive(:ask).and_return("Travel buddy energy!")
      expect(described_class.react(companion, profile)).to eq("Travel buddy energy!")
      expect(companion.companion_messages.about(profile).pluck(:role, :body)).to eq([ [ "companion", "Travel buddy energy!" ] ])
    end

    it "returns the saved reaction without calling the AI" do
      companion.companion_messages.create!(profile: profile, role: "companion", body: "Seen her before!")
      expect(described_class).not_to receive(:ask)
      expect(described_class.react(companion, profile)).to eq("Seen her before!")
    end

    it "only sends profile fields to the AI" do
      expect(described_class).to receive(:ask) do |_companion, prompt|
        expect(prompt).to include("Taylor", "I enjoy traveling.", "Woman", profile.age.to_s)
        expect(prompt).not_to include("taylor@example.com", "2000-01-01", "2000")
        "Nice!"
      end
      described_class.react(companion, profile)
    end

    it "notes when the profile has no bio" do
      profile.update!(bio: "", gender: "")
      expect(described_class).to receive(:ask).with(companion, a_string_including("Bio: No bio yet")).and_return("Mysterious!")
      described_class.react(companion, profile)
    end

    it "returns the fallback and saves nothing when the AI is unavailable" do
      allow(described_class).to receive(:ask).and_return(nil)
      expect(described_class.react(companion, profile)).to eq(CompanionService::FALLBACK)
      expect(companion.companion_messages).to be_empty
    end
  end

  describe ".reply" do
    let(:profile) { create(:profile, display_name: "Taylor") }

    it "sends the profile and the conversation so far, then saves both messages" do
      companion.companion_messages.create!(profile: profile, role: "companion", body: "She seems fun!")
      expect(described_class).to receive(:ask) do |_companion, turns|
        expect(turns.map { |turn| turn[:role] }).to eq(%w[ user assistant user ])
        expect(turns.first[:content]).to include("Taylor")
        expect(turns.last[:content]).to eq("Should I like her?")
        "Go for it!"
      end

      expect(described_class.reply(companion, profile, "Should I like her?")).to eq("Go for it!")
      expect(companion.companion_messages.about(profile).pluck(:role, :body)).to eq(
        [ [ "companion", "She seems fun!" ], [ "user", "Should I like her?" ], [ "companion", "Go for it!" ] ]
      )
    end

    it "joins the profile and message into one turn when there is no reaction yet" do
      expect(described_class).to receive(:ask) do |_companion, turns|
        expect(turns.size).to eq(1)
        expect(turns.first[:content]).to include("Taylor", "What do you think?")
        "Cute!"
      end
      described_class.reply(companion, profile, "What do you think?")
    end

    it "saves nothing when the AI is unavailable" do
      allow(described_class).to receive(:ask).and_return(nil)
      expect(described_class.reply(companion, profile, "Hello?")).to be_nil
      expect(companion.companion_messages).to be_empty
    end
  end

  describe ".ask" do
    let(:messages) { double("messages") }
    let(:fake_client) { double("client", messages: messages) }

    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("ANTHROPIC_API_KEY").and_return("test-key")
      allow(described_class).to receive(:client).and_return(fake_client)
    end

    it "returns nil without calling the API when no key is set" do
      allow(ENV).to receive(:[]).with("ANTHROPIC_API_KEY").and_return(nil)
      expect(fake_client).not_to receive(:messages)
      expect(described_class.ask(companion, "Hi")).to be_nil
    end

    it "returns the text from the AI response" do
      response = double("response", content: [ double("block", type: :text, text: " Hey! ") ])
      allow(messages).to receive(:create).and_return(response)
      expect(described_class.ask(companion, "Hi")).to eq("Hey!")
    end

    it "sends a whole conversation when given turns" do
      turns = [ { role: "user", content: "Hi" }, { role: "assistant", content: "Hey" }, { role: "user", content: "Sup" } ]
      response = double("response", content: [ double("block", type: :text, text: "Not much") ])
      expect(messages).to receive(:create).with(hash_including(messages: turns)).and_return(response)
      expect(described_class.ask(companion, turns)).to eq("Not much")
    end

    it "returns nil when the API raises an error" do
      allow(messages).to receive(:create).and_raise(Anthropic::Errors::Error, "boom")
      expect(described_class.ask(companion, "Hi")).to be_nil
    end
  end

  describe ".client" do
    around do |example|
      described_class.instance_variable_set(:@client, nil)
      example.run
      described_class.instance_variable_set(:@client, nil)
    end

    it "builds an Anthropic client" do
      expect(described_class.send(:client)).to be_a(Anthropic::Client)
    end
  end
end
