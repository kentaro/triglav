class RemoveSerialIdIndexOnHost < ActiveRecord::Migration
  def change
    remove_index :hosts, :serial_id
  end
end
