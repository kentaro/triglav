class RemoveAccessTokenSecretFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :access_token_secret
  end
end








