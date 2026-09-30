# The From address of an outgoing email sent as its agent: the agent's own mailbox name on the
# inbox's domain (jane@corp.example writing from support@acme.example sends as jane@acme.example).
# Applies when the message asks for it (content_attributes['send_as_agent']) and an agent wrote it;
# otherwise nil, and the inbox address is used. Suits teams whose agents have the same mailbox name
# on every domain they answer for, sent through an SMTP server allowed to send for the whole domain.
class Email::AgentAddressBuilder
  pattr_initialize [:message!, :channel!]

  def build
    return unless ActiveModel::Type::Boolean.new.cast(message&.content_attributes&.[]('send_as_agent'))
    return unless message.sender.is_a?(User)

    mailbox = message.sender.email.to_s.split('@').first
    domain = channel.email.to_s.split('@').last
    "#{mailbox}@#{domain}" if mailbox.present? && domain.present?
  end
end
