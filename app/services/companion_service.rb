class CompanionService
  MODEL = "claude-haiku-5-5".freeze
  FALLBACK = "Your companion is taking a quick break right now. Try again in a bit!".freeze

  def self.greet(companion)
    return companion.greeting if companion.greeting.present?

    greeting = ask(companion, "Say hi to your new friend who just joined the app. Keep it to two or three sentences.")
    return FALLBACK if greeting.nil?

    companion.update(greeting: greeting)
    greeting
  end

  def self.ask(companion, prompt)
    return nil if ENV["ANTHROPIC_API_KEY"].blank?

    response = client.messages.create(
      model: MODEL,
      max_tokens: 300,
      thinking: { type: "disabled" },
      output_config: { effort: "low" },
      system_: system_prompt(companion),
      messages: [ { role: "user", content: prompt } ]
    )

    text = response.content.select { |block| block.type == :text }.map(&:text).join.strip
    text.presence
  rescue Anthropic::Errors::Error => error
    Rails.logger.error("CompanionService: #{error.class} #{error.message}")
    nil
  end

  def self.client
    @client ||= Anthropic::Client.new(api_key: ENV["ANTHROPIC_API_KEY"], timeout: 10, max_retries: 0)
  end

  def self.system_prompt(companion)
    "You are #{companion.name}, a dating app companion who helps your friend browse profiles. " \
      "Your personality is #{companion.personality}. Keep jokes playful and kind, never make fun of " \
      "anyone's looks or identity, and talk like a real friend texting, not an assistant."
  end

  private_class_method :client, :system_prompt
end
