class AddIdentifiedContactsOnlyToChannelWebWidgets < ActiveRecord::Migration[7.2]
  def change
    add_column :channel_web_widgets, :identified_contacts_only, :boolean
  end
end
