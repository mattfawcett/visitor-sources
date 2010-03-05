use Rack::Session::Cookie
class TrafficSourceMiddleware
  def initialize(app, options={})
    @app = app
    @options = options
  end
    
  def call(env)
    @options[:custom_parameter_mapping] ||= {}
    env = TrafficSource.updated_rack_environment(env, @options[:custom_parameter_mapping])
    env[:traffic_sources] = TrafficSources.new(env["rack.session"][:traffic_sources])
    @status, @headers, @response = @app.call(env)
    [@status, @headers, @response]
  end

end