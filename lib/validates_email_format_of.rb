module ValidatesEmailFormatOf #:nodoc:

   class << self
      def email_name_regexp
         '[\w\.%\+\-]+'
      end

      def domain_head_regexp
         '(?:[A-Z0-9\-]+\.)+'
      end

      def domain_tld_regexp
         '(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum|us|mx|es)'
      end

      def full_email_regexp
         /\A#{email_name_regexp}@#{domain_head_regexp}#{domain_tld_regexp}\z/i
      end
   end

	module PluginMethods #:nodoc:
		# Validates the format of an email address.
		#
		# It uses ActiveRecord validations such:
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
				:required => "está vacío.",
				:invalid => "no es válido.",
				:too_short => "es tan corto que no debe ser valido.",
				:too_long => "es tan largo que no debe ser valido.",
				:already_taken => "ya está registrada.",
				:invalid_domain_message => "no es válido, favor de intentar con otra dirección.",
			}
			configuration = {
				:invalid_domains => []
			}
			configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
			validates_presence_of :email, :message => error_messages[:required]
			validates_format_of :email, :allow_blank => true, :with => ValidatesEmailFormatOf.full_email_regexp
			validates_length_of :email, :allow_blank => true, :within => 6..100, :too_short => error_messages[:too_short], :too_long => error_messages[:too_long]
			validates_uniqueness_of :email, :case_sensitive => false, :message => error_messages[:already_taken]
			validates_each(:email, configuration) do | record, attr_name, value |
				domain = value.split('@')[1] unless value.blank?
				message = :invalid_domain_message if !domain.nil? && configuration[:invalid_domains].include?(domain)
				record.errors.add(attr_name, error_messages[message]) if message
			end
		end
	end
end