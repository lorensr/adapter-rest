require 'sinatra'
enable :logging, :dump_errors, :raise_errors

ROUTE = '/kv-store/:hash/:key'
PROTECTED = ['bar']

$hashes = {}

helpers do
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['user', 'pass']
  end

  def assure hash
    $hashes[hash] = {} unless $hashes[hash]
  end
end

get '/kv-store/:hash/' do |hash|
  if PROTECTED.include? hash
    protected!
  end

  Marshal.dump $hashes[hash].keys
end

get ROUTE do |hash, key|
  if PROTECTED.include? hash
    protected!
  end

  assure hash
  Marshal.dump $hashes[hash][key]
end

put ROUTE do |hash, key|
  if PROTECTED.include? hash
    protected!
  end
  
  assure hash
  $hashes[hash][key] = Marshal.load(request.body.string)
end

delete ROUTE do |hash, key|
  $hashes[hash].delete key
end
