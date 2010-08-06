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
      # - validates_uniqueness_of
      # ==== Options
      # * invalid_domains
      #   - An array of domain names that are not to be used. Useful for stuff like dodgeit.com
      #     and other services.
      # ==== Example
      # * validates_email_format_of :email, :invalid_domains => %w[dodgeit.com harvard.edu]
      #   - Any email addresses @dodgeit.com or @harvard.edu will be rejected.
      def validates_email_format_of(*attr_names)
         error_messages = {
            :required => I18n.translate("activerecord.errors.messages.blank"),
            :invalid => I18n.translate("activerecord.errors.messages.invalid"),
            :already_taken => I18n.translate("activerecord.errors.messages.taken"),
            :invalid_domain_message => I18n.translate("activerecord.errors.messages.invalid_domain_message"),
         }
         configuration = {
            :invalid_domains => []
         }
         configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
         validates_presence_of :email, :message => error_messages[:required]
         validates_format_of :email, :allow_blank => true, :with => ValidatesEmailFormatOf.full_email_regexp
         validates_uniqueness_of :email, :case_sensitive => false, :message => error_messages[:already_taken]
         validates_each(:email, configuration) do | record, attr_name, value |
            domain = value.split('@')[1] unless value.blank?
            message = :invalid_domain_message if !domain.nil? && configuration[:invalid_domains].include?(domain)
            record.errors.add(attr_name, error_messages[message]) if message
         end
      end
   end
end