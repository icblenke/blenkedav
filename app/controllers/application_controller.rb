# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

protected  

  def log_error(exception) 
    super(exception)

#    begin
#      AppEngine::Mail.send_to_admins("blenkedav@blenke.com",
#                                     "BlenkeDAV Error",
#                                     { exception,
#                                       clean_backtrace(exception),
#			               params,
#                                       request.env
#                                     }.to_json
#                                    )
#    rescue => e
#      logger.error(e)
#    end
  end
end
