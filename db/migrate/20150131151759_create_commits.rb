class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :sha
      t.string :message
      t.integer :additions
      t.integer :deletions
      t.integer :diff
      t.integer :number_of_files_changed
      t.datetime :date
      t.references :user, index: true

    end
  end
end
