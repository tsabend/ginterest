class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :github_username
      t.string :github_uid
      t.string :avatar_url

      t.timestamps null: false
    end
  end
end
