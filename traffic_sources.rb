class TrafficSources < Array
  
  def initialize(string)    
    traffic_source_strings = string.split(",")
    traffic_source_strings.each do |string|
      self << TrafficSource.initialize_from_string(string)
    end
  end
  
  def to_s
    each.collect(&:to_s).join(",")
  end
end