class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :sha
      t.date :date
      t.integer :length
      t.integer :files
      t.integer :cursing
      t.integer :changes
      t.integer :punctuation
      t.integer :tense
      t.references :user, index: true
      t.string :commit_sha

      t.timestamps
    end
  end
end
