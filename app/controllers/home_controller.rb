class HomeController < ApplicationController
  before_filter :require_login, :only => :secret

  def show
    @zoom = (params[:zoom] || session[:zzom] || 1).to_i
  end

  def index
  end

  def list
    row, col, zoom = params[:offset_row].to_i, params[:offset_col].to_i, params[:zoom]
    row_size = params[:row_size].to_i
    col_size = params[:col_size].to_i
# require 'ruby-debug'
# debugger
    details = Hash.new{|a1, i1| a1[i1] = Hash.new}
    Map.where(y: (row..row+row_size), x: (col..col+col_size), current_version: true).each do |map|
      details[map.x][map.y] = {
        cell_type: map.cell_type,
        id: "#{map.x}_#{map.y}",
        level: map.level,
        owner: {
          name: map.owner.try(:name) || 'unknown',
          team: map.owner.try(:team),
          tags: map.owner.try(:tags),
          comment: map.owner.try(:comment)
        }
      }
    end
    render :json => details
  end

  def set
    details = params[:details]
    if map = Map.where(x: details['row'], y: details['col'], current_version: true).first
      map.update_attributes(current_version: false)
    end
    Map.create!(
      x: details['row'],
      y: details['col'],
      cell_type: details['cell_type'],
      level: details['level'],
      current_version: true
    )
    render :text => 'success'
  end
end
