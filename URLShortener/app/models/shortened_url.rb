class ShortenedUrl < ActiveRecord::Base
  validates :long_url, :short_url, :submitter_id, presence: true
  validates :short_url, uniqueness: true
  validates :long_url, length: { maximum: 1024 }

  validate :no_more_than_5_per_user_per_minute
  validate :no_more_than_5_per_non_premium_user

  def no_more_than_5_per_user_per_minute
    search_criteria = [
      "created_at > :time AND submitter_id = :submitter_id",
      { time: 1.minutes.ago, submitter_id: submitter_id }
    ]

    recently_created_count = self.class.where(search_criteria).count

    if recently_created_count > 5
      errors[:base] << "No more than five short urls can be created per minute"
    end
  end

  def no_more_than_5_per_non_premium_user
    user = User.find(submitter_id)
    total_created_count = self.class.where(submitter_id: user.id).count

    if !user.premium && total_created_count >= 5
      errors[:premium] << "Only premium users can create more than five short urls"
    end
  end

  belongs_to :submitter,
    foreign_key: :submitter_id,
    primary_key: :id,
    class_name: :User

  has_many :visits,
    foreign_key: :shortened_url_id,
    primary_key: :id,
    class_name: :Visit

  has_many :visitors,
    -> { distinct },
    through: :visits,
    source: :visitor

  has_many :taggings,
    foreign_key: :shortened_url_id,
    primary_key: :id,
    class_name: :Tagging

  has_many :topics,
    through: :taggings,
    source: :tag_topic

  def self.random_code
    code = SecureRandom::urlsafe_base64

    code = SecureRandom::urlsafe_base64 until !self.exists?(short_url: code)

    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(long_url: long_url, submitter_id: user.id, short_url: self.random_code)
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    time_limit = ["visits.created_at > :time", {time: 10.minutes.ago}]

    visitors.where(time_limit).count
  end
end
