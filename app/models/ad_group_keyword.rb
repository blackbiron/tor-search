class AdGroupKeyword < ActiveRecord::Base
  belongs_to :ad_group
  belongs_to :keyword
  has_many :ads, through: :ad_group
  attr_accessible :ad_group_id, :ad_group, :keyword_id, :keyword, :bid, :paused
  validates :ad_group_id, uniqueness: { scope: [:keyword_id, :ad_group_id] }

  scope :valid,
    where('ad_group_keywords.bid <= advertisers.balance') \
    .joins(:ad_group) \
    .joins('LEFT JOIN advertisers ON advertisers.id = ad_groups.advertiser_id')

  delegate :word, to: :keyword, allow_nil: true
  def status
    if paused?
      "Paused"
    else
      "Active"
    end
  end

  def ctr
    if views.present? && views > 0 && clicks.present? && clicks > 0
      clicks / views.to_f
    else
      0
    end * 100
  end

  def self.refresh_counts!
    AdGroupKeyword.connection.execute(
      <<-SQL
      UPDATE ad_group_keywords
      SET clicks = COALESCE((
        SELECT click_data.click_count
        FROM (
          SELECT count(keyword_id) as click_count, keyword_id
          FROM ad_clicks
          LEFT JOIN ads
          ON ads.id = ad_clicks.ad_id
          WHERE ads.deleted_at IS NULL
          GROUP BY keyword_id
        ) as click_data
        WHERE click_data.keyword_id = ad_group_keywords.keyword_id
      ), 0), views = COALESCE((
        SELECT view_data.views_count
        FROM (
          SELECT count(keyword_id) as views_count, keyword_id
          FROM ad_views
          LEFT JOIN ads
          ON ads.id = ad_views.ad_id
          WHERE ads.deleted_at IS NULL
          GROUP BY keyword_id
        ) as view_data
        WHERE view_data.keyword_id = ad_group_keywords.keyword_id
      ), 0)
      SQL
    )
  end
end
