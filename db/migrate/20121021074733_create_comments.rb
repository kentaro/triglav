class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :model_id
      t.string  :model_type
      t.string  :content

      t.timestamps
    end
  end
end
