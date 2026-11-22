# frozen_string_literal: true

require "rails_helper"
require "axe-capybara"
require "axe/dsl"

RSpec.describe "Page accessibility", type: :system do
  include Axe::DSL

  before do
    if ENV["CHROMEDRIVER"]
      Selenium::WebDriver::Chrome::Service.driver_path = ENV["CHROMEDRIVER"]
    end

    driven_by :selenium, using: :headless_chrome, screen_size: [ 1_200, 900 ] do |options|
      if ENV["CHROME_BIN"]
        options.binary = ENV["CHROME_BIN"]
        options.add_argument("--no-sandbox")
        options.add_argument("--disable-dev-shm-usage")
      end
    end
  end

  it "has no axe violations on the landing page" do
    visit root_path

    Axe::DSL.send(:expect, page).to Axe::DSL.send(:be_axe_clean)
  end
end
