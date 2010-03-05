require 'rubygems'
require 'sinatra'
require File.expand_path(File.dirname(__FILE__) + '/../lib/visitor_sources')

use Rack::Session::Cookie
use TrafficSourceMiddleware, :custom_parameter_mapping => {:campaign => :campaign}



get "/" do 
  request.env[:traffic_sources].to_s
end

