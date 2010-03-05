require File.expand_path(File.dirname(__FILE__) + '/test_helper')


class TrafficSourceMiddlewareTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application    
  end

  def test_should_display_traffic_source_line   
    start_time = Time.now.to_i
    get "/", params = {}, rack_env = {}
    assert last_response.ok?
    assert_equal "1|#{start_time}|direct", last_response.body
    sleep 1
    get "/", params = {:campaign => "mycampaign", :utm_medium => "cpc"}, rack_env = {}
    assert_equal "1|#{start_time}|direct,1|#{start_time+1}|cpc|||mycampaign", last_response.body
  end

end

