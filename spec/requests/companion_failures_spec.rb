require "rails_helper"

RSpec.describe "Companion failures", type: :request do
  let(:user) { create(:user, date_of_birth: 26.years.ago.to_date) }
  let!(:profile) { create(:profile, user: user, display_name: "Sam") }
  let(:prospect) do
    create(:profile, display_name: "Taylor", gender: "Woman", interested_in: "Men",
           user: create(:user, date_of_birth: 26.years.ago.to_date))
  end
  let!(:our_match) { create(:match, profile_1: profile, profile_2: prospect) }
  let(:companion) { user.companion }
  let(:limit_alert) { "Wingman needs a break. Chat again tomorrow!" }

  # Features that redirect with an alert when the AI can't answer
  def self.alert_features
    {
      "Discover chat" => [ -> { post companion_messages_path, params: { profile_id: prospect.id, body: "Thoughts?" } }, -> { swipes_path } ],
      "opener ideas" => [ -> { post match_openers_path(our_match) }, -> { match_path(our_match, anchor: "message-form") } ],
      "conversation coach" => [ -> { post match_reply_suggestion_path(our_match) }, -> { match_path(our_match, anchor: "message-form") } ],
      "profile feedback" => [ -> { post profile_feedback_path }, -> { profile_path } ]
    }
  end

  # Features that show the companion's words right on the page
  def self.page_features
    {
      "Discover reaction" => [ -> { get swipes_path }, "Like" ],
      "weekly recap" => [ -> { get companion_path }, "My week" ],
      "greeting after customizing" => [
        -> { patch companion_path, params: { companion: { name: "Rex" } } and follow_redirect! }, "Meet Rex"
      ]
    }
  end

  def fail_api_with(&failure)
    # Safe: the around hook in rails_helper.rb puts back the original key after each example
    ENV["ANTHROPIC_API_KEY"] = "test-key"
    messages = double("messages")
    allow(messages).to receive(:create, &failure)
    allow(CompanionService).to receive(:client).and_return(double("client", messages: messages))
  end

  def api_url
    URI("https://api.anthropic.com/v1/messages")
  end

  before do
    sign_in user
    Profile.where.not(id: [ profile.id, prospect.id ]).find_each do |other|
      Swipe.create!(swiper: profile, prospect: other, liked: false)
    end
  end

  {
    "is unavailable" => ->(test) { test.fail_api_with { raise Anthropic::Errors::APIConnectionError.new(url: test.api_url) } },
    "times out" => ->(test) { test.fail_api_with { raise Anthropic::Errors::APITimeoutError.new(url: test.api_url) } },
    "returns an empty reply" => ->(test) { test.fail_api_with { RSpec::Mocks::Double.new("response", content: []) } }
  }.each do |failure, setup|
    context "when the AI #{failure}" do
      before { setup.call(self) }

      alert_features.each do |feature, (action, page)|
        it "shows the friendly message for #{feature} and saves nothing" do
          instance_exec(&action)
          expect(response).to redirect_to(instance_exec(&page))
          expect(flash[:alert]).to eq(CompanionService::FALLBACK)
          expect(CompanionMessage.count).to eq(0)
        end
      end

      page_features.each do |feature, (action, still_there)|
        it "shows the friendly message for #{feature} and the rest of the page" do
          instance_exec(&action)
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(CompanionService::FALLBACK, still_there)
        end
      end
    end
  end

  context "at the daily limit" do
    before do
      Companion::DAILY_MESSAGE_LIMIT.times do
        companion.companion_messages.create!(profile: profile, role: "user", body: "Hi")
      end
      expect(CompanionService).not_to receive(:ask)
    end

    alert_features.each do |feature, (action, page)|
      it "shows the limit message for #{feature} without calling the AI" do
        instance_exec(&action)
        expect(response).to redirect_to(instance_exec(&page))
        expect(flash[:alert]).to eq(limit_alert)
      end
    end

    page_features.each do |feature, (action, still_there)|
      it "shows the limit message for #{feature} without calling the AI" do
        instance_exec(&action)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(CGI.escapeHTML(CompanionService::DAILY_LIMIT_MESSAGE), still_there)
      end
    end
  end
end
