class Commit < ActiveRecord::Base
  include CommitAlgorithmConcern
  belongs_to :user

  def self.from_algorithm(json_commit)
    p = CommitAlgorithmConcern.score_commit(json_commit)

    newobj = self.new(p)
    if !newobj.length
      newobj.length = 0
    end
    if !newobj.cursing
      newobj.cursing = 0
    end
    if !newobj.tense
      newobj.tense = 0
    end

    newobj.save
    newobj
  end

  def score
    1230* (length + cursing + tense)
  end
end
