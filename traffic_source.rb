# To minimise amount of stored data in the cookie (limited to 4KB) a traffic source gets converted to a string with variables 
# seperated by a pipe(|), different traffic sources are separated by commas(,)
#
# The string looks like the following:
#    1|1266945604|ppc|just%20tv%20stands|google|December%20Campaign|/content
# Broken down, this is what the variables mean
#    1                   => encoder_version    makes it easy to change how this works in the future without loosing old data already in peoples cookies
#    1266945604          => unix_timestamp     at which the TrafficSource was generated
#    ppc                 => medium             how the person cameto the site (main ones are cpc, direct, organic or referal)
#    just%20tv%20stands  => term               The search term that bought the user to the site [not required]
#    google              => source             Where the person came from. Could be keyword such as `google` or a domain name [not required]
#    December%20Campaign => campaign           Usually set for ppc traffic in adwords [not required]
#    /content            => content            when a referal, this is the path from which they came from [not required]

require "uri"
class TrafficSource
  attr_accessor :encoder_version, :unix_timestamp, :medium, :term, :source, :campaign, :content, :custom_parameter_mapping, :env
  
  COOKIE_LINE_PARAMETERS = ['encoder_version', 'unix_timestamp', 'medium', 'term', 'source', 'campaign', 'content']
  STANDARD_PARAMETER_MAPPING = {:medium => :utm_medium, :term => :utm_term, :source => :utm_source, :campaign => :utm_campaign, :content => :utm_content}
  
  def initialize(attributes={})
    attributes.each do |key, value|
      self.send("#{key}=", value)
    end
  end
  
  def self.updated_rack_environment(old_env)
    old_env["rack.session"][:traffic_sources] ||= ''
    traffic_sources = old_env["rack.session"][:traffic_sources].split(",")
    latest_source = TrafficSource.initialize_with_rack_env(old_env) #TODO parameter mapping
    return old_env if latest_source.to_s.nil?
    if traffic_sources.length > 0
      last_source = TrafficSource.initialize_from_string(traffic_sources.last)
      return old_env if last_source.same_as?(latest_source)
    end
    traffic_sources << latest_source
    old_env["rack.session"][:traffic_sources] = traffic_sources.join(",")
    return old_env
  end
  
  def TrafficSource.initialize_with_rack_env(env, custom_parameter_mapping = {})
    traffic_source = self.new(:env => env, :custom_parameter_mapping => custom_parameter_mapping, 
                              :unix_timestamp => Time.now.to_i, :encoder_version => 1)
    
    COOKIE_LINE_PARAMETERS.last(5).each do |attribute| 
      traffic_source.send("#{attribute}=", traffic_source.query_string_value_for(attribute.to_sym))
    end
    
    #special case for adwords auto tagging
    traffic_source.medium = 'cpc' if traffic_source.medium.nil? && !traffic_source.env["rack.request.query_hash"][:gclid].nil?
    
    if traffic_source.medium.nil?          
      if env["HTTP_REFERER"].nil?
        traffic_source.medium = "direct"      
      else        
        traffic_source.medium = "referal" unless env["HTTP_REFERER"] =~ /#{env['HTTP_HOST']}/
      end
    end    
    if traffic_source.source.nil?     
      begin 
        uri = URI.parse(env["HTTP_REFERER"])   
        traffic_source.source = uri.host
        search_engine = SearchEngine.find(traffic_source.source)
        if search_engine    
          traffic_source.source = search_engine.name
          traffic_source.term = Rack::Utils.parse_query(uri.query)[search_engine.search_parameter] if traffic_source.term.nil?
          traffic_source.medium = "organic" unless traffic_source.medium == 'cpc'
        end
        traffic_source.content = uri.path if traffic_source.content.nil? && !search_engine
      rescue; end
    end
    return traffic_source
  end
  
  def TrafficSource.initialize_from_string(string)
    string_attributes = string.split("|")
    traffic_source = TrafficSource.new(:encoder_version => string_attributes[0].to_i, :unix_timestamp => string_attributes[1].to_i)
    COOKIE_LINE_PARAMETERS.last(5).each_with_index do |attribute, index|
      traffic_source.send("#{attribute}=", string_attributes[index+2])
    end
    return traffic_source
  end
  
  def to_s
    return nil if medium.nil?
    # join each element by pipes(|), remove any unnecessary  unused pipes from the end
    COOKIE_LINE_PARAMETERS.collect{|param| self.send(param)}.join("|").gsub(/\|+$/, '')
  end

  def query_string_value_for(attribute)
    self.env["rack.request.query_hash"] ||= {}
    if custom_parameter_mapping[attribute] && env["rack.request.query_hash"][custom_parameter_mapping[attribute]]
      return env["rack.request.query_hash"][custom_parameter_mapping[attribute]]
    end
    if STANDARD_PARAMETER_MAPPING[attribute] && env["rack.request.query_hash"][STANDARD_PARAMETER_MAPPING[attribute]]
      return env["rack.request.query_hash"][STANDARD_PARAMETER_MAPPING[attribute]]
    end 
  end
  
  def same_as?(traffic_source)
    COOKIE_LINE_PARAMETERS.last(5).each do |attribute|
      return false if self.send(attribute) != traffic_source.send(attribute)
    end
    return true
  end
end