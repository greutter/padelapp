class PagesController < ApplicationController
  def home
    @date = Date.today
    @from_date = Date.today
  end

  def privio
    # @timestamp = Time.now.strftime("%H-%M-%S_")
    # EasycanchaBot.reserve
  end
end
