json.identifier @inbox_channel.identifier
json.identity_validation_enabled @inbox_channel.hmac_mandatory
json.identified_contacts_only @inbox_channel.try(:identified_contacts_only)
json.partial! 'public/api/v1/models/inbox', formats: [:json], resource: @inbox_channel.inbox
