module WidgetIdentifiedContactsOnly
  extend ActiveSupport::Concern

  GATED_ACTIONS = {
    'api/v1/widget/conversations' => %w[create],
    'api/v1/widget/messages' => %w[create update],
    'api/v1/widget/direct_uploads' => %w[create],
    'api/v1/widget/integrations/dyte' => %w[add_participant_to_meeting],
    'api/v1/widget/events' => %w[create],
    'api/v1/widget/contacts' => %w[update]
  }.freeze

  included do
    before_action :reject_unidentified_contact, if: :identified_contact_required?
  end

  private

  def identified_contact_required?
    return false unless identified_contacts_only_enabled?
    return false unless gated_action?

    action_requires_identification?
  end

  def identified_contacts_only_enabled?
    @web_widget&.identified_contacts_only? && @contact_inbox.present?
  end

  def gated_action?
    GATED_ACTIONS.fetch(controller_path, []).include?(action_name)
  end

  def action_requires_identification?
    return false if controller_path == 'api/v1/widget/events' && params[:name] != 'campaign.triggered'
    return false if controller_path == 'api/v1/widget/contacts' && params[:identifier].present?

    true
  end

  def reject_unidentified_contact
    return if @contact_inbox.hmac_verified?

    render json: { error: 'Contact must be identified' }, status: :forbidden
  end
end
