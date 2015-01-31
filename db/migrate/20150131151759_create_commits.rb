class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.integer :score
      t.string :feedback
      t.references :user, index: true
      t.string :commit_sha

      t.timestamps
    end
  end
end
