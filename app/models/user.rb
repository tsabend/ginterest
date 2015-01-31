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
end
