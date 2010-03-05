require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class TrafficSourcesTest < Test::Unit::TestCase
  context "TrafficSourcesTest" do
    context "retrieve" do
      should "return 2 traffic source objects if I have 2 strings in the cookie" do
        @rack_env = EXAMPLE_RACK_ENV.dup
        @rack_env["rack.session"][:traffic_sources] = "1|#{Time.now.to_i}|direct,1|#{Time.now.to_i}|cpc|Product One|google|MyCamp1"
        assert_equal 2, TrafficSources.retrieve(@rack_env).length
      end
    end
  end
end