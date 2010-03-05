require 'rubygems'
require 'sinatra'
require File.expand_path(File.dirname(__FILE__) + '/search_engine')
require File.expand_path(File.dirname(__FILE__) + '/traffic_source')
require File.expand_path(File.dirname(__FILE__) + '/traffic_sources')
require File.expand_path(File.dirname(__FILE__) + '/traffic_source_middleware')

use Rack::Session::Cookie
use TrafficSourceMiddleware, :custom_parameter_mapping => {:campaign => :campaign}



get "/" do 
  request.env[:traffic_sources].to_s
end

