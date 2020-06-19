class FormattedEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    add_error(record, attribute, "is not an email") unless value.include?("@")
    add_error(record, attribute, "does not contain domain") unless value.include?(Settings.domain)
  end

  private

  def add_error(record, attribute, message)
    record.errors[attribute] << message
  end
end
