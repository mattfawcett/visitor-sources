use Rack::Session::Cookie
class TrafficSourceMiddleware
  def initialize(app)
    @app = app
  end
    
  def call(env)
    env = TrafficSource.updated_rack_environment(env)
    @status, @headers, @response = @app.call(env)
    [@status, @headers, env.inspect+'<a href="/">home</a>']
  end

end
