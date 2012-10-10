class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :provider
      t.integer :uid
      t.string  :name
      t.string  :image
      t.string  :token

      t.timestamps
    end

    add_index :users, [:provider, :uid], unique: true
    add_index :users, [:token], unique: true
  end
end
