class SearchEngine
  SEARCH_ENGINES = {
  "google" => "q",
  "yahoo" => "p",
  "msn" => "q",
  "aol" => "query",
  "aol" => "encquery",
  "lycos" => "query",
  "ask" => "q",
  "altavista" => "q",
  "netscape" => "query",
  "cnn" => "query",
  "looksmart" => "qt",
  "about" => "terms",
  "mamma" => "query",
  "alltheweb" => "q",
  "gigablast" => "q",
  "voila" => "rdata",
  "virgilio" => "qs",
  "live" => "q",
  "baidu" => "wd",
  "alice" => "qs",
  "yandex" => "text",
  "najdi" => "q",
  "aol" => "q",
  "club-internet" => "query",
  "mama" => "query",
  "seznam" => "q",
  "search" => "q",
  "wp" => "szukaj",
  "onet" => "qt",
  "netsprint" => "q",
  "google.interia" => "q",
  "szukacz" => "q",
  "yam" => "k",
  "pchome" => "q",
  "kvasir" => "searchExpr",
  "sesam" => "q",
  "ozu" => "q",
  "terra" => "query",
  "nostrum" => "query",
  "mynet" => "q",
  "ekolay" => "q",
  "search.ilse" => "search_for"}
  
  attr_accessor :name, :search_parameter
  
  def self.find(domain)
    SEARCH_ENGINES.each do |name, search_parameter|
      if domain =~ /#{name}/
        engine =  SearchEngine.new
        engine.name = name
        engine.search_parameter = search_parameter
        return engine
      end
    end
    return nil
  end
end