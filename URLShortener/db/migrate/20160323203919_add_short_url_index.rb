class AddShortUrlIndex < ActiveRecord::Migration
  def change
    add_index :shortened_urls, [:submitter_id, :short_url]
  end
end
