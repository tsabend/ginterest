require 'open-uri'
module GitScraper

  def self.get_all_pushes(username)
    all_pushes = []
    events = JSON.parse(open("https://api.github.com/users/#{username}/events").read)
    events.each do |event|
      if event['type'] = 'PushEvent'
        all_pushes << event
      end
    end
    all_pushes
  end

  def self.get_all_commits(username)
    commits = []
    get_all_pushes(username).each do |push|
      if push['payload']['commits'] != nil 
        push['payload']['commits'].each do |commit|
          commits << JSON.parse(open(commit['url']).read)
        end
      end
    end
    commits
  end

  def self.get_latest_push(username)
    get_all_pushes(username).first
  end

  def self.most_recent_commit(username)
    recent_commits = []
    get_latest_push(username)['payload']['commits'].each do |commit|
      recent_commits << JSON.parse(open(commit['url']).read)
    end
    recent_commits
  end
end
