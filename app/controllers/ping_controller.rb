class PingController < ActionController::Base

  def index
    logger 'PingController::index was called'
    render :text => "pong"
  end

end
