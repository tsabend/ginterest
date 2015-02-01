class Commit < ActiveRecord::Base
  include CommitAlgorithmConcern
  belongs_to :user

  def score
    commit_score
  end

  def title
    message.split("\n").first
  end
  
end
