require "flipper"
require "flipper/adapters/redis"

client = Redis.new(url: ENV['REDIS_URL'])
adapter = Flipper::Adapters::Redis.new(client)

$flipper = Flipper.new(adapter)
