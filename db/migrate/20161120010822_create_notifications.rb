class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
    	t.references	:to
    	t.references	:from
    	t.integer		:target_id
    	t.boolean		:read, default: false
    	t.string		:category
      t.timestamps null: false
    end
  end
end
