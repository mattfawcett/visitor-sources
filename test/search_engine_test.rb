require File.expand_path(File.dirname(__FILE__) + '/test_helper')
                    
class SearchEngineTest < Test::Unit::TestCase
  context "SearchEngineTest" do
    context "find" do
      should "return a search engine if one matches" do
        engine = SearchEngine.find("www.google.com")
        assert_equal "google", engine.name
        assert_equal "q", engine.search_parameter
      end
      
      should "return nil if no engine found" do
        engine = SearchEngine.find("www.fakeengine.com")
        assert_nil engine
      end
    end
  end
end