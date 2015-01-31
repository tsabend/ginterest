class User < ActiveRecord::Base
  has_many :commits
  belongs_to :cohort

  def get_all_pushes
    all_pushes = []
    uri = URI.parse("https://api.github.com/users/#{username}/events?client_id=#{ENV['GITHUB_KEY']}&client_secret=#{ENV['GITHUB_SECRET']}")
    response = Net::HTTP.get_response(uri)
    events = JSON.parse(response.body)
    events.each do |event|
      if event['type'] = 'PushEvent'
        all_pushes << event
      end
    end
    all_pushes
  end

  def get_all_commits
    get_all_pushes.map do |push|
      if push && push['payload'] && push['payload']['commits']
        push['payload']['commits'].each do |commit|
          uri = URI.parse(commit['url']+"?client_id=#{ENV['GITHUB_KEY']}&client_secret=#{ENV['GITHUB_SECRET']}")
          response = Net::HTTP.get_response(uri)
          JSON.parse(response.body)
        end
      end
    end
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
    todays_scores = commits.where(["created_at < ?", 0.days.ago])
    a = todays_scores.map {|commit| commit.score }
    a.reduce(:+) / a.length
  end
end
