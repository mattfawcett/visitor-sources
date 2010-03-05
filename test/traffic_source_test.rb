require File.expand_path(File.dirname(__FILE__) + '/test_helper')

# Priority of variables set
# custom variables configured when using the plugin take the most priority
# if no custom variable matches, then the standard google variables take priority: 'utm_source', 'utm_medium', 'utm_campaign', 'utm_term', 'utm_content', 'utm_campaign' 
# if no match standard google variables then try and work out the required data from referers etc
                    
class TrafficSourceTest < Test::Unit::TestCase
  context "TrafficSourceTest" do
    setup do
      @rack_env = EXAMPLE_RACK_ENV.dup
      @custom_variable_matches = {:campaign => :custom_campaign, :term => :custom_keywords, :medium => :custom_medium}        
    end
    context "initialize_with_rack_env" do     
         
      context "when there are custom variables in the url present" do
        should "use the custom variables to set the correct TrafficSource" do
          @rack_env["rack.request.query_hash"] = {:custom_campaign => "MyCamp1", :custom_keywords => "Product One", :gclid => "AutoAdwordsTaggingClid"}
          @rack_env["HTTP_REFERER"] = "http://www.google.co.uk/search"
          traffic_source = TrafficSource.initialize_with_rack_env(@rack_env, @custom_variable_matches)
          assert_equal "cpc", traffic_source.medium
          assert_equal "MyCamp1", traffic_source.campaign
          assert_equal "Product One", traffic_source.term
          assert_equal Time.now.to_i, traffic_source.unix_timestamp
          assert_equal "1|#{Time.now.to_i}|cpc|Product One|google|MyCamp1", traffic_source.to_s
        end
      
        should "use presume organic if no gclid and from a search engine" do          
          @rack_env["rack.request.query_hash"] = {:custom_campaign => "MyCamp1", :custom_keywords => "Product One"}
          @rack_env["HTTP_REFERER"] = "http://www.google.co.uk/search"
          traffic_source = TrafficSource.initialize_with_rack_env(@rack_env, @custom_variable_matches)
          assert_equal "organic", traffic_source.medium
          assert_equal "MyCamp1", traffic_source.campaign
          assert_equal "Product One", traffic_source.term
          assert_equal Time.now.to_i, traffic_source.unix_timestamp
          assert_equal "1|#{Time.now.to_i}|organic|Product One|google|MyCamp1", traffic_source.to_s
        end
      
        should "assign to cpc if a custom variable says thats the case" do
          @rack_env["rack.request.query_hash"] = {:custom_campaign => "MyCamp1", :custom_keywords => "Product One", :custom_medium => "cpc"}
          @rack_env["HTTP_REFERER"] = "http://www.google.co.uk/search"
          traffic_source = TrafficSource.initialize_with_rack_env(@rack_env, @custom_variable_matches)
          assert_equal "cpc", traffic_source.medium
          assert_equal "MyCamp1", traffic_source.campaign
          assert_equal "Product One", traffic_source.term
          assert_equal Time.now.to_i, traffic_source.unix_timestamp
          assert_equal "1|#{Time.now.to_i}|cpc|Product One|google|MyCamp1", traffic_source.to_s
        end
      end
     
      context "when no custom or standard variables matching" do
        context "when there is no referer" do
          should "add create a TrafficSource instance with medium of direct" do
            @rack_env["HTTP_REFERER"] = nil
            traffic_source = TrafficSource.initialize_with_rack_env(@rack_env, @custom_variable_matches)
            assert_equal "direct", traffic_source.medium
            assert_equal Time.now.to_i, traffic_source.unix_timestamp
            assert_equal "1|#{Time.now.to_i}|direct", traffic_source.to_s
          end
        end
    
        context "when there is a referer" do
          context "when the referer is an interal address" do
            should "have no medium and to_s return nil" do
              @rack_env["HTTP_REFERER"] = "http://localhost:9393/some/path"
              traffic_source = TrafficSource.initialize_with_rack_env(@rack_env, @custom_variable_matches)
              assert_nil traffic_source.medium
              assert_nil traffic_source.to_s
            end
          end
      
          context "when the referer is external" do
            should "have a medium of referer with source and content" do
              @rack_env["HTTP_REFERER"] = "http://matthewfawcett.co.uk/some/path"
              traffic_source = TrafficSource.initialize_with_rack_env(@rack_env, @custom_variable_matches)
              assert_equal "referal", traffic_source.medium
              assert_equal "matthewfawcett.co.uk", traffic_source.source
              assert_equal "/some/path", traffic_source.content
              assert_equal "1|#{Time.now.to_i}|referal||matthewfawcett.co.uk||/some/path", traffic_source.to_s
            end
            
            should "assign to a search engine with correct keywords if referer matches" do
              @rack_env["HTTP_REFERER"] = "http://google.co.uk/search?q=mysearchterms"
              traffic_source = TrafficSource.initialize_with_rack_env(@rack_env, @custom_variable_matches)
              assert_equal "organic", traffic_source.medium
              assert_equal "google", traffic_source.source
              assert_equal "mysearchterms", traffic_source.term
              assert_nil   traffic_source.content
              assert_equal "1|#{Time.now.to_i}|organic|mysearchterms|google", traffic_source.to_s
            end
          end
        end
      end    
      
      context "using standard google variables" do
        should "should assign to ppc if the variables say so" do
          @rack_env["rack.request.query_hash"] = {:utm_campaign => "MyCamp1", :utm_term => "Product One", :utm_medium => "cpc", :utm_source => "google", :utm_term => "Product One"}
          @rack_env["HTTP_REFERER"] = "http://www.google.co.uk/search"
          traffic_source = TrafficSource.initialize_with_rack_env(@rack_env, @custom_variable_matches)
          assert_equal "cpc", traffic_source.medium
          assert_equal "MyCamp1", traffic_source.campaign
          assert_equal "Product One", traffic_source.term
          assert_equal Time.now.to_i, traffic_source.unix_timestamp
          assert_equal "1|#{Time.now.to_i}|cpc|Product One|google|MyCamp1", traffic_source.to_s
        end
      end
    end
  
    context "query_string_value_for" do
      setup do
        @traffic_source = TrafficSource.new
        @traffic_source.custom_parameter_mapping = {:campaign => :custom_campaign, :keyword => :custom_keywords, :medium => :custom_medium}        
      end
      
      should "use the custom value if there is a match" do    
        @traffic_source.env = @rack_env.merge("rack.request.query_hash" => {:custom_campaign => "mattscustomcampaign", :utm_campaign => "standardcampaign"})          
        assert_equal "mattscustomcampaign", @traffic_source.query_string_value_for(:campaign)
      end
      
      should "use the standard value if there is a match and no custom match" do    
        @traffic_source.env = @rack_env.merge("rack.request.query_hash" => {:utm_campaign => "standardcampaign"})          
        assert_equal "standardcampaign", @traffic_source.query_string_value_for(:campaign)
      end
      
      should "use the standard match if we don't even have any custom parameter mapping" do    
        @traffic_source.custom_parameter_mapping = {}        
        @traffic_source.env = @rack_env.merge("rack.request.query_hash" => {:custom_campaign => "mattscustomcampaign", :utm_campaign => "standardcampaign"})          
        assert_equal "standardcampaign", @traffic_source.query_string_value_for(:campaign)
      end
      
      should "be nil if no match" do    
        @traffic_source.env = @rack_env.merge("rack.request.query_hash" => {})          
        assert_nil @traffic_source.query_string_value_for(:campaign)
      end
      
    end
    
    context "updated_rack_environment" do

      should "not update the enviroment if the current TrafficSource#to_s is nil" do
        @rack_env["HTTP_REFERER"] = "http://localhost:9393/some/path"
        rack_env = TrafficSource.updated_rack_environment(@rack_env)
        assert_equal "", rack_env["rack.session"][:traffic_sources]
      end

      should "not update the enviroment if the last TrafficSource#to_s is the same as the current traffic source" do
        @rack_env["HTTP_REFERER"] = nil
        rack_env = TrafficSource.updated_rack_environment(@rack_env)
        assert_equal "1|#{Time.now.to_i}|direct", rack_env["rack.session"][:traffic_sources]

        rack_env = TrafficSource.updated_rack_environment(@rack_env)
        assert_equal "1|#{Time.now.to_i}|direct", rack_env["rack.session"][:traffic_sources]
      end

      should "update the traffic source if the current one is differenty from the last one" do
        @rack_env["HTTP_REFERER"] = nil
        rack_env = TrafficSource.updated_rack_environment(@rack_env)
        assert_equal "1|#{Time.now.to_i}|direct", rack_env["rack.session"][:traffic_sources]

        rack_env["rack.request.query_hash"] = {:utm_campaign => "MyCamp1", :utm_term => "Product One", :utm_medium => "cpc", :utm_source => "google", :utm_term => "Product One"}
        rack_env["HTTP_REFERER"] = "http://www.google.co.uk/search"
        rack_env = TrafficSource.updated_rack_environment(@rack_env)
        assert_equal "1|#{Time.now.to_i}|direct,1|#{Time.now.to_i}|cpc|Product One|google|MyCamp1", rack_env["rack.session"][:traffic_sources]      
      end
    end
    
  end
  
  
  
  context "same_as?" do
    setup do
      @source_1 = TrafficSource.new(:encoder_version => 1, :unix_timestamp => Time.now.to_i, :medium => 'cpc', 
                                    :term => 'myterm', :source => 'google', :campaign => 'mycamp')
      @source_2 = @source_1.dup
    end
    
    should "be true if all the main fields are the same" do
      assert @source_1.same_as?(@source_2)
      @source_2.encoder_version = 2
      @source_2.unix_timestamp = 1234
      assert @source_1.same_as?(@source_2)
    end
    
    should "be false if one of the fields are different" do
      @source_2.medium = "direct"
      assert !@source_1.same_as?(@source_2)
    end
  end
  
  context "initialize_from_string" do
    should "create a new TrafficSource using the correct parameters from the string" do
      string = "1|123456|organic|mysearchterms|google"
      source = TrafficSource.initialize_from_string(string)
      assert_equal 1,               source.encoder_version
      assert_equal 123456,          source.unix_timestamp
      assert_equal "organic",       source.medium
      assert_equal "mysearchterms", source.term
      assert_equal "google",        source.source
      assert_nil    source.campaign
      assert_nil    source.content
    end
  end
  
  
  
end                    