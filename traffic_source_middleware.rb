use Rack::Session::Cookie
class TrafficSourceMiddleware
  def initialize(app)
    @app = app
  end
    
  def call(env)
    env = TrafficSource.updated_rack_environment(env)
    env[:traffic_sources] = TrafficSources.retrieve(env["rack.session"][:traffic_sources])
    @status, @headers, @response = @app.call(env)
    [@status, @headers, @response]
  end

end
