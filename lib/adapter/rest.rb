require 'adapter'

module Adapter
  module Rest
    def read(key)
      decode(client.get(key_for(key)))
    end

    def write(key, value)
      client.put(key_for(key), encode(value))
    end

    def delete(key)
      client.delete(key_for(key))
    end

    def clear
      keys = read ''
      keys.each do |key|
        delete key
      end
    end
  end
end

Adapter.define(:rest, Adapter::Rest)
