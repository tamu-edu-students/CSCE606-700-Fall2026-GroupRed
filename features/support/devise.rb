require "cucumber/rspec/doubles"

World(Warden::Test::Helpers)

Before { Warden.test_mode! }
After { Warden.test_reset! }
