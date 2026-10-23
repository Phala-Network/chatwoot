# The address an agent's email reply is sent from when the message asks for it
# (content_attributes['send_as_agent']): the agent's mailbox name on the inbox's domain, so
# jane@corp.example answering support@acme.example sends as jane@acme.example. Nil otherwise, and
# for OAuth inboxes, which can only send as their own account. The inbox's SMTP server must be
# allowed to send for the whole domain.
class Email::AgentAddressBuilder
  pattr_initialize [:message!, :channel!]

  def build
    return unless requested? && message.sender.is_a?(User) && !oauth?

    "#{message.sender.email.split('@').first}@#{channel.email.split('@').last}"
  end

  private

  def requested?
    ActiveModel::Type::Boolean.new.cast(message&.content_attributes&.[]('send_as_agent'))
  end

  def oauth?
    channel.google? || channel.microsoft?
  end
end
