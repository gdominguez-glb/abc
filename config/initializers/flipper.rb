require "flipper"
require "flipper/adapters/redis"

client = Redis.new(url: ENV['REDIS_URL'])
adapter = Flipper::Adapters::Redis.new(client)

$flipper = Flipper.new(adapter)

if Rails.env.development?
  $flipper[:coupon_code].enable
end

if Rails.env.qa?
  $flipper[:coupon_code].enable
end

if Rails.env.staging?
  $flipper[:coupon_code].enable
end

if Rails.env.production?
  $flipper[:coupon_code].disable
end
