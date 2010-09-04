class DashboardController < ApplicationController
  FLAG_LIST_COOKIE = :gre_vocab_flag_list
  
  def index
    @sets = WordSet.all
  end
  
  def study
    @set = WordSet.find_by_id(params[:id])
    @set_attributes = @set.attributes.merge(:words => @set.words.map(&:attributes))
  end
  
  def flag_list
    flag_list_cookie = cookies[FLAG_LIST_COOKIE] || []
    flag_list = JSON.parse(flag_list_cookie)
    @words = Word.find_all_by_id(flag_list)
  end
  
end
