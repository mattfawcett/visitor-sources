require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'shoulda'
require 'delorean'
require 'base64'
require File.expand_path(File.dirname(__FILE__) + '/app')

EXAMPLE_RACK_ENV = {
"rack.session"=>{:traffic_sources=>""}, 
"HTTP_HOST"=>"localhost:9393", 
"HTTP_ACCEPT"=>"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", 
"SERVER_NAME"=>"localhost", 
"rack.request.cookie_hash"=>{"rack.session"=>"BAh7BjoUdHJhZmZpY19zb3VyY2VzIghBQkM=\n"}, 
"rack.url_scheme"=>"http", 
"REQUEST_PATH"=>"/", 
"HTTP_USER_AGENT"=>"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6", 
"HTTP_KEEP_ALIVE"=>"115", 
"rack.errors"=>{}, 
"HTTP_ACCEPT_LANGUAGE"=>"en-us,en;q=0.5", 
"SERVER_PROTOCOL"=>"HTTP/1.1", 
"rack.version"=>[1, 0], 
"rack.run_once"=>false, 
"SERVER_SOFTWARE"=>"Mongrel 1.1.5", 
"PATH_INFO"=>"/", 
"REMOTE_ADDR"=>"::1", 
"rack.request.cookie_string"=>"rack.session=BAh7BjoUdHJhZmZpY19zb3VyY2VzIghBQkM%3D%0A", 
"HTTP_REFERER"=>"http://localhost:9393/", 
"SCRIPT_NAME"=>"", 
"rack.multithread"=>true, 
"HTTP_VERSION"=>"HTTP/1.1", 
"HTTP_COOKIE"=>"rack.session=BAh7BjoUdHJhZmZpY19zb3VyY2VzIghBQkM%3D%0A", 
"rack.request.form_vars"=>"", 
"rack.multiprocess"=>false, 
"REQUEST_URI"=>"/", 
"rack.request.form_input"=>{}, 
"rack.request.query_hash"=>{}, 
"HTTP_ACCEPT_CHARSET"=>"ISO-8859-1,utf-8;q=0.7,*;q=0.7", 
"SERVER_PORT"=>"9393", 
"rack.session.options"=>{:domain=>nil, :expire_after=>nil, :path=>"/"}, 
"REQUEST_METHOD"=>"GET", 
"rack.request.form_hash"=>{}, 
"rack.request.query_string"=>"", 
"QUERY_STRING"=>"", 
"rack.input"=>{},
"HTTP_ACCEPT_ENCODING"=>"gzip,deflate", 
"HTTP_CONNECTION"=>"keep-alive", 
"GATEWAY_INTERFACE"=>"CGI/1.2"}