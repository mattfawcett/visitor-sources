require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class TrafficSourcesTest < Test::Unit::TestCase
  context "TrafficSourcesTest" do
    context "retrieve" do      
      should "allow the raw string to be used to build the array of TrafficSources" do
        assert_equal 2, TrafficSources.retrieve("1|#{Time.now.to_i}|direct,1|#{Time.now.to_i}|cpc|Product One|google|MyCamp1").length
      end
    end
  end
end