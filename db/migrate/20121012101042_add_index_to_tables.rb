class AddIndexToTables < ActiveRecord::Migration
  def change
    add_index :services, :name
    add_index :roles,    :name
    add_index :hosts,    :ip_address
    add_index :hosts,    :name
  end
end
