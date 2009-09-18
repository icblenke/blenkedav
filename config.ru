require 'rubygems'
require 'appengine-rack'
require 'appengine-apis/xmpp'
require 'stringio'

AppEngine::Rack.configure_app(
    :ssl_enabled => true,
    :application => "blenkedav",
    :version => 12)

AppEngine::Rack.app.inbound_services << :xmpp_message

%w{.git R examples/ db/ doc/ log/ script/ test/ tmp/}.each do |x|
  AppEngine::Rack.app.resource_files.exclude "/#{x}**"
end
ENV['RAILS_ENV'] = AppEngine::Rack.environment
require 'config/environment'

map "/_ah/xmpp" do
  run lambda {|env|
    data = env['rack.input'].read
    env['CONTENT_LENGTH'] = data.length
    env['rack.input'] = StringIO.new(data)
    request = Rack::Request.new(env)
    message = AppEngine::XMPP::Message.new(request)
    message.reply(message.body)
    [200, {}, 'ok']
  }
end

map '/src' do
  use AppEngine::Rack::AdminRequired
  use AppEngine::Rack::SSLRequired
  run ActionController::Dispatcher.new
end

map '/' do
  run ActionController::Dispatcher.new
end

