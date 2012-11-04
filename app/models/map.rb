class Map < ActiveRecord::Base
  belongs_to :owner
  attr_accessible :cell_type, :level, :x, :y, :current_version
end
