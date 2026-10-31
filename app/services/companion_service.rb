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

  def self.react(companion, profile)
    saved = companion.companion_messages.about(profile).find_by(role: "companion")
    return saved.body if saved

    reaction = ask(companion, "#{profile_details(profile)}\n\nGive your friend a quick, honest reaction to this profile in one or two sentences.")
    return FALLBACK if reaction.nil?

    companion.companion_messages.create!(profile: profile, role: "companion", body: reaction.truncate(500)).body
  end

  def self.reply(companion, profile, text)
    history = companion.companion_messages.about(profile).map do |message|
      { role: message.role == "user" ? "user" : "assistant", content: message.body }
    end
    turns = [ { role: "user", content: profile_details(profile) }, *history, { role: "user", content: text } ]

    answer = ask(companion, merge_turns(turns))
    return nil if answer.nil?

    CompanionMessage.transaction do
      companion.companion_messages.create!(profile: profile, role: "user", body: text)
      companion.companion_messages.create!(profile: profile, role: "companion", body: answer.truncate(500))
    end
    answer
  end

  def self.merge_turns(turns)
    turns.slice_when { |a, b| a[:role] != b[:role] }.map do |group|
      { role: group.first[:role], content: group.map { |turn| turn[:content] }.join("\n\n") }
    end
  end

  def self.profile_details(profile)
    details = [ "Your friend is looking at this dating profile:", "Name: #{profile.display_name}", "Age: #{profile.age}" ]
    details << "Gender: #{profile.gender}" if profile.gender.present?
    details << "Bio: #{profile.bio.presence || 'No bio yet'}"
    details.join("\n")
  end

  def self.ask(companion, prompt)
    return nil if ENV["ANTHROPIC_API_KEY"].blank?

    response = client.messages.create(
      model: MODEL,
      max_tokens: 300,
      thinking: { type: "disabled" },
      output_config: { effort: "low" },
      system_: system_prompt(companion),
      messages: prompt.is_a?(Array) ? prompt : [ { role: "user", content: prompt } ]
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
      "anyone's looks or identity, and talk like a real friend texting, not an assistant. " \
      "Keep every reply to a few sentences."
  end

  private_class_method :client, :system_prompt, :profile_details, :merge_turns
end
