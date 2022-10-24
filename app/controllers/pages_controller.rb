class PagesController < ApplicationController
  def home
    @club = Club.second
    @date = Date.today
    @from_date = Date.today
  end

  def privio
    
  end
end
