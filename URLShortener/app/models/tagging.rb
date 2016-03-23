class Tagging < ActiveRecord::Base
  validates :shortened_url_id, :tag_topic_id, presence: true

  belongs_to :shortened_url,
    foreign_key: :shortened_url_id,
    primary_key: :id,
    class_name: :ShortenedUrl

  belongs_to :tag_topic,
    foreign_key: :tag_topic_id,
    primary_key: :id,
    class_name: :TagTopic
end
