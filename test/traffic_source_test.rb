require File.expand_path(File.dirname(__FILE__) + '/test_helper')


                    
class TrafficSourceTest < Test::Unit::TestCase
 
  context "initialize_with_rack_env" do   
    context "when there is no referer" do
      should "add create a TrafficSource instance with medium of direct" do
        rack_env = EXAMPLE_RACK_ENV
        rack_env["HTTP_REFERER"] = nil
        traffic_source = TrafficSource.initialize_with_rack_env(rack_env)
        assert_equal "direct", traffic_source.medium
        assert_equal Time.now.to_i, traffic_source.unix_timestamp
        assert_equal "1|#{Time.now.to_i}|direct", traffic_source.to_string
      end
    end
    
    context "when there is a referer" do
      context "when the referer is an interal address" do
        
      end
      
      context "when the refere is external" do
        
      end
    end
    
  end


end                    