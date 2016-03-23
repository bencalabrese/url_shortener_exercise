class ShortenedUrl < ActiveRecord::Base
  validates :long_url, :short_url, :submitter_id, presence: true
  validates :short_url, uniqueness: true

  belongs_to :submitter,
    foreign_key: :submitter_id,
    primary_key: :id,
    class_name: :User

  has_many :visits,
    foreign_key: :shortened_url_id,
    primary_key: :id,
    class_name: :Visit

  has_many :visitors,
    through: :visits,
    source: :visitor

  def self.random_code
    code = SecureRandom::urlsafe_base64

    code = SecureRandom::urlsafe_base64 until !self.exists?(short_url: code)

    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(long_url: long_url, submitter_id: user.id, short_url: self.random_code)
  end

  def num_clicks
    visitors.select(:user_id).count
  end

  def num_uniques
    visitors.select(:user_id).distinct.count
  end

  def num_recent_uniques
    time_limit = ["visits.created_at > :time", {time: 10.minutes.ago}]

    visitors.select(:user_id).where(time_limit).distinct.count
  end
end
