class AddActiveToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :active, :boolean, default: true
  end
end
