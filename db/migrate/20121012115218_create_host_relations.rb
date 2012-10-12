class CreateHostRelations < ActiveRecord::Migration
  def change
    create_table :host_relations do |t|
      t.integer :service_id
      t.integer :role_id
      t.integer :host_id
    end

    add_index :host_relations, [:service_id, :role_id, :host_id], unique: true
    add_index :host_relations, :host_id
  end
end
