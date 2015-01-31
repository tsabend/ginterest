class Cohort < ActiveRecord::Base
  has_many :users
  has_many :commits, through: :users
end
