class Commit < ActiveRecord::Base
  include CommitAlgorithmConcern
  belongs_to :user

  def self.from_algorithm(json_commit)
    p = CommitAlgorithmConcern.score_commit(json_commit)
    self.create(p)
  end
end
