module ActiveRecord #:nodoc:
	module Validations #:nodoc:
		module ClassMethods
			# Validates the format of an email address.
			#
			# Also uses ActiveRecord validations such:
			# - validates_presence_of
			# - validates_format_of
			# - validates_length_of
			# - validates_uniqueness_of
			# ==== Options
			# * <b>invalid_domains</b>
			#   - An array of domain names that are not to be used. Useful for stuff like dodgeit.com
			#     and other services.
			# ==== Example
			# * <tt>validates_email_format_of :email, :invalid_domains => %w[dodgeit.com harvard.edu]</tt>
			#   - Any email addresses @dodgeit.com or @harvard.edu will be rejected.
			def validates_email_format_of(*attr_names)
				error_messages = {
					:required => "es requisito.",
					:invalid => "no es válido.",
					:too_short => "es tan corto que no debe ser valido.",
					:too_long => "es tan largo que no debe ser valido.",
					:already_taken => "ya está registrada.",
					:invalid_domain_message => "ingresada no es válida, favor de intentar con otra.",
				}
				configuration = {
					:invalid_domains => []
				}
				configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
				validates_each(:email, configuration) do |record, attr_name, value|
					validates_presence_of attr_name, :message => error_messages[:required]
					validates_format_of attr_name, :with => RE_EMAIL_OK
					validates_length_of attr_name, :within => 3..100, :too_short => error_messages[:too_short], :too_long => error_messages[:too_long]
					validates_uniqueness_of attr_name, :case_sensitive => false, :message => error_messages[:already_taken]
					domain = value.split('@')[1] unless value.blank?
					message = :invalid_domain_message if !domain.nil? && configuration[:invalid_domains].include?(domain)
					record.errors.add(attr_name, error_messages[message]) if message
				end
			end
		end
	end
end