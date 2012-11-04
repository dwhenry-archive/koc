class Owner < ActiveRecord::Base
  belongs_to :team
  attr_accessible :comments, :name, :tags
end
