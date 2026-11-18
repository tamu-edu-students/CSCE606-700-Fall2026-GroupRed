# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Header navigation", type: :request do
  let(:user) do
    User.create!(email: "nav@example.com", date_of_birth: Date.new(2000, 1, 1), password: "password123")
  end

  it "groups account links in a details menu for signed-in users" do
    sign_in user
    get root_path

    expect(response.body).to include('<details class="account-menu">')
    expect(response.body).to include("<summary>Account</summary>")
    expect(response.body).to include(%(href="#{reports_path}">My reports</a>))
    expect(response.body).to include(%(href="#{blocks_path}">Blocked people</a>))
  end

  it "does not show the account menu to visitors" do
    get root_path

    expect(response.body).not_to include("account-menu")
    expect(response.body).not_to include("My reports")
  end
end
