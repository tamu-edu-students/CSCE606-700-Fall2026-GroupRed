# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Shared accessibility features", type: :request do
  it "renders the signed-out navigation and skip link" do
    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('href="#main-content"')
    expect(response.body).to include('aria-label="Primary navigation"')
    expect(response.body).to include("Sign in")
    expect(response.body).to include("Sign up")
    expect(response.body).to include('<main id="main-content" tabindex="-1">')
  end

  it "renders a friendly not-authorized page" do
    get not_authorized_path

    expect(response).to have_http_status(:forbidden)
    expect(response.body).to include("<h1>Not authorized</h1>")
    expect(response.body).to include("Return to WingmAIn")
  end

  it "keeps the production 404 page friendly" do
    page = Rails.root.join("public", "404.html").read

    expect(page).to include("<h1>Page not found</h1>")
    expect(page).to include("Return to WingmAIn")
  end
end
