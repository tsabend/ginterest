class User < ActiveRecord::Base
  has_many :commits
  belongs_to :cohort

  def get_all_pushes
    all_pushes = []
    events = JSON.parse(open("https://api.github.com/users/#{username}/events?client_id=#{ENV['GITHUB_KEY']}&client_secret=#{ENV['GITHUB_SECRET']}").read)
    events.each do |event|
      if event['type'] = 'PushEvent'
        all_pushes << event
      end
    end
    all_pushes
  end

  def get_all_commits
    commits = []
    get_all_pushes.each do |push|
      if push['payload']['commits'] != nil
        push['payload']['commits'].each do |commit|
          commits << JSON.parse(open(commit['url']+"?client_id=#{ENV['GITHUB_KEY']}&client_secret=#{ENV['GITHUB_SECRET']}").read)
        end
      end
    end
    commits
  end



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
