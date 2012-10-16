class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.integer :model_id
      t.string  :model_type
      t.string  :tag
      t.text    :diff

      t.timestamps
    end
  end
end
