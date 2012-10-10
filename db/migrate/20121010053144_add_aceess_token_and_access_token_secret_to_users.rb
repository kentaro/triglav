class AddAceessTokenAndAccessTokenSecretToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access_token, :string
    add_column :users, :access_token_secret, :string
  end
end
