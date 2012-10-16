class AddDeletedAtToModels < ActiveRecord::Migration
  def change
    %w(users services roles hosts).each do |model|
      add_column model.to_sym, :deleted_at, :datetime
    end
  end
end







