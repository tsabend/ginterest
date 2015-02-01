class User < ActiveRecord::Base
  has_many :commits
  belongs_to :cohort

  def get_commits
    get_commits_from_urls.each do |commit|
      unless self.commits.find_by(sha: commit[:sha]) || commit[:message][0..4] == "Merge"
          puts "adding commit #{commit[:sha]}"
          self.commits.create(commit)
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

  def todays_commits
    commits.where(["date < ?", 0.days.ago])
  end

  def score
    (avg_score * freq_modifier).round(2)
  end

  def avg_score
    return 0 if todays_commits.length == 0
    todays_scores = todays_commits.map {|commit| commit.score }
    todays_scores.reduce(:+) / todays_scores.length
  end

  def freq_modifier
    return 0 if todays_commits.length == 0
    time_elapsed = (todays_commits.first.date - todays_commits.last.date) / 3600
    (todays_commits.length / time_elapsed).round(2)
  end

  private

  def get_commits_from_urls
    get_commit_urls_from_pushes.map do |url|
      uri = URI.parse(url+"?client_id=#{ENV['GITHUB_KEY']}&client_secret=#{ENV['GITHUB_SECRET']}")
      response = Net::HTTP.get_response(uri)
      message = JSON.parse(response.body)
      {
        sha: message["sha"],
        message: message["commit"]["message"],
        diff: message["stats"]["total"],
        additions: message["stats"]["additions"],
        deletions: message["stats"]["deletions"],
        number_of_files_changed: message["files"].size,
        date: message["commit"]["author"]["date"]
      }
    end
  end

  def get_commit_urls_from_pushes
    uri = URI.parse("https://api.github.com/users/#{username}/events?client_id=#{ENV['GITHUB_KEY']}&client_secret=#{ENV['GITHUB_SECRET']}")
    response = Net::HTTP.get_response(uri)
    pushes = JSON.parse(response.body)
    commit_arrays = pushes.select {|p| p["payload"]["commits"]}
    # wow. this is awful, but now we ignore other people's commits.
    urls = commit_arrays.map {|push| push["payload"]["commits"]
      .select{|commit| commit["author"]["email"] == self.email}
      .map{|commits| commits["url"]}}.flatten
  end

end
