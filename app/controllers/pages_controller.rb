class PagesController < ApplicationController
  def home
    @club = Club.first
    @date = Date.today + 3.days
  end
end
