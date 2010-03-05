class TrafficSources < Array
  
  #The input can be either a comma separated string or a rack environment
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