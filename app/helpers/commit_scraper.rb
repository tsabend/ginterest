require 'open-uri'
module GitScraper

  def get_latest_push(username)
    events = JSON.parse(open("https://api.github.com/users/#{username}/events").read)
    events.each do |event|
      if event['type'] = 'PushEvent'
        return event
      end
    end
  end

  def most_recent_commit(username)
    latest = get_latest_push(username)
    recent_commits = []
    latest['payload']['commits'].each do |commit|
      recent_commits << JSON.parse(open(commit['url']).read)
    end
    recent_commits
  end

end
