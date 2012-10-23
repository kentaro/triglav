class AddMuninToService < ActiveRecord::Migration
  def change
    add_column :services, :munin_url, :string
  end
end
