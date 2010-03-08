class TrafficSourceMiddleware
  def initialize(app, options={})
    @app = app
    @options = options
  end
    
  def call(env)
    @options[:custom_parameter_mapping] ||= {}        
    @options[:ignore_duplicate_source_within] ||= 120 #2 mins
    env["rack.request.query_hash"] = Rack::Utils.parse_query(env["QUERY_STRING"]) 
    env = TrafficSource.updated_rack_environment(env, @options[:custom_parameter_mapping])
    env[:traffic_sources] = TrafficSources.new(env["rack.session"][:traffic_sources])        
    @status, @headers, @response = @app.call(env)    
    [@status, @headers, @response]
  end

end