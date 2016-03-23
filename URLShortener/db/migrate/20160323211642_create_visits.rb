class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :user_id, null: false
      t.integer :shortened_url_id, null: false

      t.timestamps null: false
    end

    add_index :visits, [:user_id, :shortened_url_id]
  end
end
