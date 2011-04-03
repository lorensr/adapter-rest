require 'httparty'

class RestfulKeyValueStore
  include HTTParty

  def initialize(base_uri, namespace, username=nil, password=nil)
    self.class.base_uri base_uri
    @namespace = namespace
    @options = {}
    @options[:basic_auth] = {username: username, password: password} if username
  end
  
  def get(key)
    self.class.get @namespace + key, @options
  end

  def put(key, value)
    @options[:body] = value
    self.class.put @namespace + key, @options
  end

  def delete(key)
    self.class.delete @namespace + key, @options
  end
end
