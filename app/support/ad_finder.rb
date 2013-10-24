class AdFinder
  attr_accessor :query
  attr_accessor :limit
  def initialize(query,limit=5)
    self.query = query
    self.limit = limit
  end
  def ads
    if @selected_ads.nil?
      Rails.logger.info "Fetching ads for #{self.query}"
      @selected_ads = (ads_by_keyword | generic_ads).uniq.sort do |s,f|
        (f.onion? ? s.bid : s.bid * 0.75 ) <=> (s.onion? ? f.bid : f.bid * 0.75 )
      end.map(&:reload).take(limit)
      Rails.logger.info "\tFound #{@selected_ads.count} ads"
    end
    @selected_ads
  end
  protected
  def ads_by_keyword
    if @keyword_ads.nil?
      @keyword_ads = Ad.select("ads.*").limit(limit).available.joins(:advertiser, ad_keywords: :keyword). \
        where('advertisers.balance > ad_keywords.bid').where("keywords.word in (?)", query_words)
      @keyword_ads.map do |ad|
        ad.keyword_id = ad.ad_keywords.joins(:keyword).where("keywords.word in (?)", query_words).first.id
      end
    end
    @keyword_ads
  end
  def generic_ads
    @generic_ads ||= Ad.limit(limit).available.joins(:advertiser). \
      where('advertisers.balance > ads.bid').where("(select count(*) from ad_keywords where ad_id = ads.id) = 0").order(:bid, :created_at).map{|ad| ad.bid = ad.bid / 2; ad}
  end
  def self.amazon_ad(query)
    url = "http://www.amazon.com/gp/search?ie=UTF8&camp=1789&creative=9325&index=aps&keywords=#{query}&linkCode=ur2&tag=tor-search-20"
    Ad.new(path: url, display_path: 'amazon.com', bid: 0, title: "#{query} on Amazon", line_1: "Look for #{query}", line_2: 'on Amazon.com', protocol_id: 1, ppc: true, include_path: true)

  end
  def query_words
    query.split(/\s/)
  end
end