Around do |_scenario, block|
  key = ENV.delete("ANTHROPIC_API_KEY")
  block.call
ensure
  ENV["ANTHROPIC_API_KEY"] = key if key
end
