  require 'appengine-apis/urlfetch'
  Net::HTTP = AppEngine::URLFetch::HTTP
  hdoc = Net::HTTP.get(URI.parse("http://tumblr.com"))
