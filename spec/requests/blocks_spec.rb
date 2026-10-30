require "rails_helper"

RSpec.describe "Blocks", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:alex) { create(:profile, display_name: "Alex").user }

  context "when not signed in" do
    it "sends the visitor to sign in" do
      get blocks_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "does not create a block" do
      expect { post person_block_path(alex) }.not_to change(Block, :count)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when signed in" do
    before { sign_in user }

    it "blocks a person and explains what that means" do
      expect { post person_block_path(alex) }.to change(Block, :count).by(1)
      expect(user.blocking?(alex)).to be(true)
      expect(response).to redirect_to(blocks_path)
      expect(flash[:notice]).to eq("You blocked Alex. They can no longer see or contact you.")
    end

    it "does not create a second block for the same person" do
      create(:block, blocker: user, blocked: alex)
      expect { post person_block_path(alex) }.not_to change(Block, :count)
      expect(response).to redirect_to(blocks_path)
    end

    it "does not let a user block themselves" do
      expect { post person_block_path(user) }.not_to change(Block, :count)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You can't block yourself")
    end

    it "handles a person who does not exist" do
      expect { post person_block_path(person_id: 0) }.not_to change(Block, :count)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("That profile isn't available.")
    end

    it "lists the people the user blocked" do
      create(:block, blocker: user, blocked: alex)
      get blocks_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Unblock Alex")
    end

    it "does not list blocks made by other users" do
      create(:block, blocked: alex)
      get blocks_path
      expect(response.body).to include("You haven't blocked anyone.")
      expect(response.body).not_to include("Alex")
    end

    it "unblocks a person" do
      create(:block, blocker: user, blocked: alex)
      expect { delete person_block_path(alex) }.to change(Block, :count).by(-1)
      expect(response).to redirect_to(blocks_path)
      expect(flash[:notice]).to eq("Alex is unblocked.")
    end

    it "cannot remove a block someone else made" do
      create(:block, blocker: alex, blocked: user)
      expect { delete person_block_path(alex) }.not_to change(Block, :count)
      expect(flash[:alert]).to eq("That person isn't blocked.")
    end
  end
end
