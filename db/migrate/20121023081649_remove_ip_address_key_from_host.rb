class RemoveIpAddressKeyFromHost < ActiveRecord::Migration
  def change
    remove_index :hosts, [:ip_address]
  end
end
