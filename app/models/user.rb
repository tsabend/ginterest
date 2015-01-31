class User < ActiveRecord::Base
  has_many :commits
  belongs_to :cohort
end
