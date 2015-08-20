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

    # Returns true if class is a match for the exception
    def self.matches_exception?(e)
      false && e
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

    def self.find_response_code(e)
      r = e.response
      r && r[:status]
    end

    def self.find_first_error(e)
      r = e.response
      r && r[:body] && (json = JSON.parse(r[:body])) && json.first
    end

    def self.find_error_code(e)
      error = find_first_error(e)
      error && error['errorCode']
    end

    def self.find_message(e)
      error = find_first_error(e)
      error && error['message']
    end
  end

  # DuplicateRecord
  class DuplicateRecord < Error
    register_exception(self)

    def self.matches_exception?(e)
      e.is_a?(Faraday::Error::ClientError) && find_response_code(e) == 400 &&
        find_error_code(e) == 'DUPLICATE_VALUE'
    end

    def initialize(e = nil, message = nil)
      super(e, message)
      return if !e || !e.is_a?(Faraday::Error::ClientError)
      @message = self.class.find_message(e) unless message
    end

    def duplicate_id
      message = self.class.find_message(original_exception)
      matches = message.match(/duplicates value on record with id: (.+),|\Z/)
      matches[1] if matches.present?
    end
  end

  # RateLimit
  class RateLimit < Error
    register_exception(self)

    def self.matches_exception(e)
      e.is_a?(Faraday::Error::ClientError) && find_response_code(e) == 400 &&
        find_message(e) =~ /exceeded/
    end

    def initialize(e = nil, message = nil)
      return super(e, message) unless e
    end
  end
end
