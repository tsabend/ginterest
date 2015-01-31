class User < ActiveRecord::Base
  has_many :commits
  belongs_to :cohort

  def self.create_with_omniauth(auth)
    create do |user|
      user.github_uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.username = auth["info"]["nickname"]
      user.avatar_url = auth["info"]["image"]
    end
  end

  def score
    todays_scores = commits.where(["created_at < ?", 0.days.ago]).pluck(:score)
    if todays_scores.first
      todays_scores.reduce(:+) / todays_scores.size
    else
      "No commits today"
    end
  end
end
