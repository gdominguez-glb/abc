class CloudfrontInvalidator
  def initialize(path, identifier, style=:original)
    @path = path
    @identifier = identifier
    @cf = AWS::CloudFront.new(
      :access_key_id => ENV['aws_access_key_id'],
      :secret_access_key => ENV['aws_secret_access_key']
    )
  end

  def invalidate!
    @cf.client.create_invalidation(
      distribution_id: ENV['cloudfront_distribution_id'],
      invalidation_batch: {
        paths: {
          quantity: 1,
          items: [@path]
        },
        caller_reference: @identifier
      }
    )
  end
end
