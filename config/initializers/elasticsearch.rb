Searchkick.client =
  Elasticsearch::Client.new(
    hosts: host_name,
    retry_on_failure: true,
    port: '443',
    scheme: 'https'
  )

def host_name
  return 'elastic:9200' if ENV['RAILS_ENV'].eql?('development')
  ENV['ELASTICSEARCH_URL'].to_s
end
