Searchkick.client =
  Elasticsearch::Client.new(
    hosts: ENV['RAILS_ENV'].eql?('development').present? ? 'elastic:9200' : ENV['ELASTICSEARCH_URL'].to_s,
    retry_on_failure: true,
    port: '443',
    scheme: 'https'
  )
