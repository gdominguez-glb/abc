module GmSalesforce
  # Error
  class Error < StandardError
    attr_writer :default_message
    attr_reader :original_exception

    class_variable_set(:@@exceptions, [])

    # Add a new exception class
    def self.register_exception(klass)
      @@exceptions << klass
    end

    def self.client_error?(e)
      e.is_a?(Faraday::Error::ClientError)
    end

    # Returns true if class is a match for the exception
    def self.matches_exception?(_e)
      false
    end

    # Returns an appropriate exception class for the given exception
    def self.generate(e, message = nil)
      klass = @@exceptions.find { |x| x.matches_exception?(e) }
      return klass.new(e, message) if klass
      new(e, message)
    end

    def initialize(e = nil, message = nil)
      @original_exception = e
      @message = message || e.try(:message)
    end

    def to_s
      @message || @default_message
    end

    # Gets and parses the rate info string.  E.g. "api-usage=11/72000"
    def self.rate_limit_info(e)
      headers = e.try(:response).try('[]', :headers)
      usage_string = headers.try('[]', 'sforce-limit-info')
      use_values = ((usage_string || '').split('=').last || '').split('/')
      { usage: use_values.first.to_i, limit: use_values.last.to_i }
    end

    def rate_usage
      e = original_exception
      e && self.class.rate_limit_info(e)[:usage]
    end

    def rate_limit
      e = original_exception
      e && self.class.rate_limit_info(e)[:limit]
    end
  end

  # ConnectionFailed
  class ConnectionFailed < Error
    register_exception(self)

    def self.matches_exception?(e)
      e.is_a?(Faraday::ConnectionFailed)
    end
  end

  # ClientError
  class ClientError < Error
    def self.error_code
      nil
    end

    def self.error_400?(e)
      find_response_code(e) == 400
    end

    def self.matches_exception?(e)
      client_error?(e) && error_400?(e) && (error_code.blank? ||
        find_error_code(e) == error_code)
    end

    def initialize(e = nil, message = nil)
      super(e, message)
      return if !e || !self.class.client_error?(e)
      @message = self.class.find_message(e) unless message
    end

    def self.find_response_section(e, section_id)
      r = e.response
      r && r[section_id]
    end

    def self.find_response_code(e)
      find_response_section(e, :status)
    end

    def self.find_first_error(e)
      body = find_response_section(e, :body)
      body && (body.is_a?(Array) ? body.first : JSON.parse(body).try(:first))
    end

    def self.find_error_property(e, property_name)
      find_first_error(e).try('[]', property_name)
    end

    def self.find_error_code(e)
      find_error_property(e, 'errorCode')
    end

    def self.find_message(e)
      find_error_property(e, 'message')
    end
  end

  class DuplicatesDetected < ClientError
    register_exception(self)

    def self.error_code
      'DUPLICATES_DETECTED'
    end
  end

  # DuplicateRecord
  class DuplicateRecord < ClientError
    register_exception(self)

    def self.error_code
      'DUPLICATE_VALUE'
    end

    def duplicate_id
      message = self.class.find_message(original_exception)
      matches = message.match(/duplicates value on record with id: (.+?)(,|\Z)/)
      matches[1] if matches.present?
    end
  end

  # DeletedRecord
  class DeletedRecord < Error
    register_exception(self)

    def self.matches_exception?(e)
      e.is_a?(Faraday::ResourceNotFound) && e.message =~ /\AENTITY_IS_DELETED/
    end
  end

  # FailedActivation
  class FailedActivation < ClientError
    register_exception(self)

    def self.error_code
      'FAILED_ACTIVATION'
    end
  end

  # RateLimit
  class RateLimit < ClientError
    register_exception(self)

    def self.matches_exception?(e)
      client_error?(e) && error_400?(e) && find_message(e) =~ /exceeded/
    end
  end
end
