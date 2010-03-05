class TrafficSources < Array
  
  #The input can be either a comma separated string or a rack environment
  def self.retrieve(string)    
    traffic_source_strings = string.split(",")
    traffic_sources = TrafficSources.new
    traffic_source_strings.each do |string|
      traffic_sources << TrafficSource.initialize_from_string(string)
    end
    return traffic_sources
  end
end