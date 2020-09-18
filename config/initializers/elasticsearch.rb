Searchkick.client =
  Elasticsearch::Client.new(
    hosts: ENV['RAILS_ENV'].eql?('development') ? "elastic:9200" : "#{ENV['ELASTICSEARCH_URL']}:9200",
    retry_on_failure: true
  )
