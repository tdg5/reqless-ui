require "qless"
require "qless/server"
require "qmore-server"

reqless_redis_url = ENV["REQLESS_UI_REDIS_URL"]
qmore_refresh_frequency_seconds = ENV["QMORE_REFRESH_FREQUENCY_SECONDS"]

client = Qless::Client.new(:url => reqless_redis_url)
Qmore.client = client
Qmore.configuration = Qmore::Configuration.new
Qmore.monitor = Qmore::Persistence::Monitor.new(
  Qmore.persistence,
  qmore_refresh_frequency_seconds,
)

builder = Rack::Builder.new do
  map("/") do
    run Qless::Server.new(client)
  end
end

run(builder)
