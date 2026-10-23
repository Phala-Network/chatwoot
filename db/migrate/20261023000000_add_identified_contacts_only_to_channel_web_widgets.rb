class AddIdentifiedContactsOnlyToChannelWebWidgets < ActiveRecord::Migration[7.0]
  def change
    add_column :channel_web_widgets, :identified_contacts_only, :boolean, default: false, null: false
  end
end
