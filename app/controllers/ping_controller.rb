class PingController < ActionController::Base

  def index
    logger.info 'PingController: index'
    render :text => "pong"
  end

end
