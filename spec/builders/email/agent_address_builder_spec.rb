require 'rails_helper'

RSpec.describe Email::AgentAddressBuilder do
  let(:account) { create(:account) }
  let(:agent) { create(:user, account: account, email: 'jane@corp.example') }
  let(:channel) { create(:channel_email, email: 'support@acme.example', account: account) }
  let(:conversation) { create(:conversation, account: account, inbox: channel.inbox) }

  def message_with(content_attributes, sender: agent)
    create(:message, conversation: conversation, account: account, sender: sender, message_type: :outgoing,
                     content_attributes: content_attributes)
  end

  it "returns the agent's mailbox on the inbox domain when the message asks for it" do
    expect(described_class.new(message: message_with({ send_as_agent: true }), channel: channel).build).to eq('jane@acme.example')
  end

  it 'returns nil when the message does not ask for it' do
    expect(described_class.new(message: message_with({}), channel: channel).build).to be_nil
    expect(described_class.new(message: message_with({ send_as_agent: false }), channel: channel).build).to be_nil
  end

  it 'returns nil for a message not written by an agent' do
    bot = create(:agent_bot, account: account)
    expect(described_class.new(message: message_with({ send_as_agent: true }, sender: bot), channel: channel).build).to be_nil
  end
end
