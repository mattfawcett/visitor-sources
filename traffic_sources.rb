class TrafficSources < Array
  def self.retrieve(rack_env)
    traffic_source_strings = rack_env["rack.session"][:traffic_sources].split(",")
    traffic_sources = TrafficSources.new
    traffic_source_strings.each do |string|
      traffic_sources << TrafficSource.initialize_from_string(string)
    end
    return traffic_sources
  end
end