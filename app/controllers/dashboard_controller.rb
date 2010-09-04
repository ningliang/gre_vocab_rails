class DashboardController < ApplicationController
  
  def index
    @sets = WordSet.all
  end
  
  def study
    @set = WordSet.find_by_id(params[:id])
    @set_attributes = @set.attributes.merge(:words => @set.words.map(&:attributes))
  end

end
