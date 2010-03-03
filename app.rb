require 'rubygems'
require 'sinatra'
require 'traffic_source'
require 'traffic_source_middleware'

use Rack::Session::Cookie
use TrafficSourceMiddleware



get "/" do
  session[:traffic_sources] ||= ''
  session[:traffic_sources] << TrafficSource.new(env).to_s# unless session[:traffic_sources].spl
  session[:traffic_sources]
end

