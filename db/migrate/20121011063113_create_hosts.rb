class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string :ip_address
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
