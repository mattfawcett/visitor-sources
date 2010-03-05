require 'rubygems'
require 'sinatra'
require File.expand_path(File.dirname(__FILE__) + '/search_engine')
require File.expand_path(File.dirname(__FILE__) + '/traffic_source')
require File.expand_path(File.dirname(__FILE__) + '/traffic_source_middleware')

use TrafficSourceMiddleware



get "/" do
  session[:traffic_sources] ||= 's'
  # session[:traffic_sources] << TrafficSource.new(env).to_s# unless session[:traffic_sources].spl
  session[:traffic_sources].inspect
end

