require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'app'

class TrafficSourceMiddlewareTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application    
  end

  def test_redirect_logged_in_users_to_dashboard    
    get "/", params = {}, rack_env = {}
    assert last_response.ok?
    puts "APP IS "+app.sessions.inspect
    assert_equal last_response.headers["Set-Cookie"], ""
  end

end

