class PagesController < ApplicationController
  def home
    @club = Club.first
    @date = Date.today
    @from_date = Date.today
  end
end
