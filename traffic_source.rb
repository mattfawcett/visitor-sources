# To minimise amount of stored data in the cookie (limited to 4KB) a traffic source gets converted to a string with variables 
# seperated by a pipe(|), different traffic sources are separated by commas(,)
#
# The string looks like the following:
#    1|1266945604|ppc|just%20tv%20stands|google|December%20Campaign|/content
# Broken down, this is what the variables mean
#    1                   => encoder_version    makes it easy to change how this works in the future without loosing old data already in peoples cookies
#    1266945604          => unix_timestamp     at which the TrafficSource was generated
#    ppc                 => medium             how the person cameto the site (will be wither ppc, direct, or referal)
#    just%20tv%20stands  => term               The search term that bought the user to the site [not required]
#    google              => source             Where the person came from. Could be keyword such as `google` or a domain name [not required]
#    December%20Campaign => campaign           Usually set for ppc traffic in adwords [not required]
#    /content            => content            when a referal, this is the path from which they came from [not required]

require "uri"
class TrafficSource
  attr_accessor :encoder_version, :unix_timestamp, :medium, :term, :source, :campaign, :content
  COOKIE_LINE_PARAMETERS = ['encoder_version', 'unix_timestamp', 'medium', 'term', 'source', 'campaign', 'content']
  
  def self.updated_rack_environment(old_env)
    old_env
  end
  
  def TrafficSource.initialize_with_rack_env(env)
    traffic_source = self.new
    if !env["HTTP_REFERER"].nil? && env["HTTP_REFERER"] =~ /#{env["HTTP_HOST"]}/
      return traffic_source
    end
    traffic_source.unix_timestamp = Time.now.to_i
    traffic_source.encoder_version = 1
    if env["HTTP_REFERER"].nil?
      traffic_source.medium = "direct"      
    else
      uri = URI.parse(env["HTTP_REFERER"])
      traffic_source.medium = "referal"      
      traffic_source.source = uri.host
      traffic_source.content = uri.path
    end
    return traffic_source
  end
  
  def to_s
    return nil if medium.nil?
    # join each element by pipes(|), remove any unnecessary  unused pipes from the end
    COOKIE_LINE_PARAMETERS.collect{|param| self.send(param)}.join("|").gsub(/\|+$/, '')
  end


end