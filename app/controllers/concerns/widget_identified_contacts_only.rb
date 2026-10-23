module WidgetIdentifiedContactsOnly
  extend ActiveSupport::Concern

  included do
    before_action :reject_unidentified_contact, if: :identified_contact_required?
  end

  private

  def identified_contact_required?
    return false unless @web_widget&.identified_contacts_only?
    return false unless @contact_inbox

    case controller_path
    when 'api/v1/widget/conversations'
      action_name == 'create'
    when 'api/v1/widget/messages'
      %w[create update].include?(action_name)
    when 'api/v1/widget/direct_uploads'
      action_name == 'create'
    when 'api/v1/widget/integrations/dyte'
      action_name == 'add_participant_to_meeting'
    when 'api/v1/widget/events'
      action_name == 'create' && params[:name] == 'campaign.triggered'
    when 'api/v1/widget/contacts'
      action_name == 'update' && params[:identifier].blank?
    else
      false
    end
  end

  def reject_unidentified_contact
    return if @contact_inbox.hmac_verified?

    render json: { error: 'Contact must be identified' }, status: :forbidden
  end
end
