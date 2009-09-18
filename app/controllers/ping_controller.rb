class PingController < ActionController::Base

  def index
    render :text => "pong"
  end

end
