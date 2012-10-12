class AddIndexToTables < ActiveRecord::Migration
  def change
    add_index :services, :name
    add_index :roles,    :name
    add_index :hosts,    :ip_address, unique: true
    add_index :hosts,    :name,       unique: true
  end
end
