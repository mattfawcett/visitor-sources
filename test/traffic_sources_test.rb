require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class TrafficSourcesTest < Test::Unit::TestCase
  context "TrafficSourcesTest" do
    context "new" do      
      should "allow the raw string to be used to build the array of TrafficSources" do
        assert_equal 2, TrafficSources.new("1|#{Time.now.to_i}|direct,1|#{Time.now.to_i}|cpc|Product One|google|MyCamp1").length
      end
    end
    
    context "to_s" do
      should "call to_s on each TrafficSource instance and join with commas" do
        traffic_sources = TrafficSources.new("1|#{Time.now.to_i}|direct,1|#{Time.now.to_i}|cpc|Product One|google|MyCamp1")
        assert_equal "1|#{Time.now.to_i}|direct,1|#{Time.now.to_i}|cpc|Product One|google|MyCamp1", traffic_sources.to_s
      end
    end
  end
end