class ApplicationController < ActionController::Base
  # console

  before_action :redirect_to_domain

  def redirect_to_domain
    host = request.host
    path = path = request.fullpath.split("?")[0]
    if host == 'padelapp.cl' && path == "/"
      redirect_to 'https://padelapp.cl'
    end
  end
end
