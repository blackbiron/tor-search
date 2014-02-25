class TrendingController < ApplicationController
  def index
    @trending_searches = read_through_cache('trending_searches', 1.hour) do
      Query.trending
    end
    @max = 0
    @trending_searches.each { |s| @max = s[:volume].to_f if s[:volume].to_f > @max }
    @max *= 1.2
  end

  def search

  end

  def search_graph
    keywords = params[:q].map{|q|q.downcase.strip}.reject(&:empty?)[0..2]
    if current_advertiser
      @mixpanel_tracker.track(current_advertiser.id, 'Checked Trending', {keywords: keywords})
    else
      @mixpanel_tracker.track('Guest', 'Checked Trending', {keywords: keywords})
    end

    g = Gruff::Line.new('600x200')

    g.title = "Searches for #{keywords.join(', ')}"

    #g.theme_greyscale
    start = DateTime.parse('September 1, 2013').to_date
    months = ((Date.today - start).to_f / 30).to_i + 1
    labels = []
    months.times do |i|
      labels << (start + i.months)
    end
    g.labels = {}
    g.hide_legend = false
    g.maximum_value = 1
    g.minimum_value = 0
    g.hide_dots = true

    keywords.each do |keyword|
      searches_data = []
      searches = Search.joins(:query) \
        .where('lower(term) like ?', "%#{keyword}%") \
        .group("to_char(searches.created_at, 'YYYY-MM')") \
        .order("to_char(searches.created_at, 'YYYY-MM')").count


      labels.each_with_index do |date, index|
        d = date.strftime('%Y-%m')
        g.labels[index] = date.strftime('%b %Y')
        searches_data << if searches[d]
          searches[d]
        else 0
        end
      end

      g.data(keyword.titleize, searches_data)
    end


    data = g.to_blob('PNG')
    #end
    send_data data, type: 'image/png', disposition: :inline
  end
end