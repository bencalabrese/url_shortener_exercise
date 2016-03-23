class CreateTagTopics < ActiveRecord::Migration
  def change
    create_table :tag_topics do |t|
      t.string :topic, null: false
      t.timestamps null: false
    end
  end
end
