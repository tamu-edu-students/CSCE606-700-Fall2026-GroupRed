require "rails_helper"

RSpec.describe "Companions", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:companion) { user.companion }

  context "when not signed in" do
    it "sends the visitor to sign in" do
      get edit_companion_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "does not change any companion" do
      patch companion_path, params: { companion: { name: "Rex" } }
      expect(response).to redirect_to(new_user_session_path)
      expect(companion.reload.name).to eq("Wingman")
    end
  end

  context "when signed in" do
    before do
      sign_in user
      allow(CompanionService).to receive(:ask).and_return("Hey, it's me!")
    end

    it "shows a link to customize the companion" do
      get companion_path
      expect(response.body).to include("Customize Wingman")
    end

    it "shows the edit form with the current values" do
      get edit_companion_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Customize your companion", "Wingman", "playful and honest")
    end

    it "updates the name and personality" do
      patch companion_path, params: { companion: { name: "Rex", personality: "grumpy but loyal" } }
      expect(companion.reload).to have_attributes(name: "Rex", personality: "grumpy but loyal")
      expect(response).to redirect_to(companion_path)
      expect(flash[:notice]).to eq("Rex is all set.")
    end

    it "greets the user again in the new voice" do
      companion.update!(greeting: "Old greeting")
      patch companion_path, params: { companion: { name: "Rex", personality: "grumpy but loyal" } }
      follow_redirect!
      expect(response.body).to include("Meet Rex", "Hey, it&#39;s me!")
      expect(response.body).not_to include("Old greeting")
    end

    {
      "a blank name" => [ { name: "" }, "Name can't be blank" ],
      "a name over 40 characters" => [ { name: "a" * 41 }, "Name is too long (maximum is 40 characters)" ],
      "a blank personality" => [ { personality: "   " }, "Personality can't be blank" ],
      "a personality over 200 characters" => [ { personality: "a" * 201 }, "Personality is too long (maximum is 200 characters)" ]
    }.each do |description, (invalid_fields, message)|
      it "rejects #{description} and explains why" do
        patch companion_path, params: { companion: invalid_fields }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Your companion could not be saved", CGI.escapeHTML(message))
        expect(companion.reload.name).to eq("Wingman")
      end
    end

    it "only changes the name and personality" do
      other = create(:user).companion
      patch companion_path, params: { companion: { name: "Rex", greeting: "injected", user_id: other.user_id } }
      expect(companion.reload).to have_attributes(name: "Rex", greeting: nil, user_id: user.id)
      expect(other.reload.name).to eq("Wingman")
    end
  end
end
