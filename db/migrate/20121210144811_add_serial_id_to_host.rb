class AddSerialIdToHost < ActiveRecord::Migration
  def change
    add_column :hosts, :serial_id, :string, default: nil
    add_index :hosts, :serial_id, :unique => true
  end
end
