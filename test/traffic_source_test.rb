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
        assert_equal "1|#{Time.now.to_i}|direct", traffic_source.to_s
      end
    end
    
    context "when there is a referer" do
      context "when the referer is an interal address" do
        should "have no medium and to_s return nil" do
          rack_env = EXAMPLE_RACK_ENV
          rack_env["HTTP_REFERER"] = "http://localhost:9393/some/path"
          traffic_source = TrafficSource.initialize_with_rack_env(rack_env)
          assert_nil traffic_source.medium
          assert_nil traffic_source.to_s
        end
      end
      
      context "when the referer is external" do
        context "and its not adwords" do
          should "have a medium of referer with source and content" do
            rack_env = EXAMPLE_RACK_ENV
            rack_env["HTTP_REFERER"] = "http://matthewfawcett.co.uk/some/path"
            traffic_source = TrafficSource.initialize_with_rack_env(rack_env)
            assert_equal "referal", traffic_source.medium
            assert_equal "matthewfawcett.co.uk", traffic_source.source
            assert_equal "/some/path", traffic_source.content
            assert_equal "1|#{Time.now.to_i}|referal||matthewfawcett.co.uk||/some/path", traffic_source.to_s
          end
                    
          should "support campaign tracking with referers" do
            
          end
        end
      end
    end    
  end

end                    