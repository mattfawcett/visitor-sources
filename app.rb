require 'rubygems'
require 'sinatra'
require File.expand_path(File.dirname(__FILE__) + '/search_engine')
require File.expand_path(File.dirname(__FILE__) + '/traffic_source')
require File.expand_path(File.dirname(__FILE__) + '/traffic_sources')
require File.expand_path(File.dirname(__FILE__) + '/traffic_source_middleware')

use TrafficSourceMiddleware, :custom_parameter_mapping => {:campaign => :campaign}



get "/" do 
  request.env[:traffic_sources].to_s + '<a href="/"></a>'
#  request.env.inspect
end

