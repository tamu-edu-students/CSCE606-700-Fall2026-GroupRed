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
