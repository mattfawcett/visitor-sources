require File.expand_path(File.dirname(__FILE__) + '/test_helper')


                    
class TrafficSourceMiddlewareTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application    
  end

  def updated_rack_environment    
    get "/", params = {}, rack_env = {}
    assert last_response.ok?
    cookie_value = last_response.headers["Set-Cookie"][/rack.session=(.*);/, 1]
    puts "COOKIE VAL IS #{cookie_value}"
    decoded_cookie_value = Base64.decode64(cookie_value)
    puts "decoded val is #{decoded_cookie_value}"
    assert_equal "1|#{Time.now.to_i}|direct", decoded_cookie_value
    #puts "APP IS "+app.sessions.inspect
    #assert_equal last_response.headers["Set-Cookie"], ""
    #Base64.decode64(enc)

  end

end                    