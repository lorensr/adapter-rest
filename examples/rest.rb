require_relative '../lib/adapter/rest'
require_relative 'restful-key-value-store'

foo_client = RestfulKeyValueStore.new 'localhost:4567', '/kv-store/foo/'
foo_adapter = Adapter[:rest].new(foo_client)

foo_adapter.write('a', '1')
puts 'Should be 1: ' + foo_adapter.get('a')

foo_adapter.delete 'a'
puts 'Should be nil: ' + foo_adapter.get('a').inspect

bar_client = RestfulKeyValueStore.new 'localhost:4567', '/kv-store/bar/', 'user', 'pass'
bar_adapter = Adapter[:rest].new(bar_client)

bar_adapter.write('b', '3')
foo_adapter.write('a', '1')
foo_adapter.write('b', '2')

puts 'Should be 3: ' + bar_adapter.get('b')
puts 'Should be 2: ' + foo_adapter.get('b')

foo_adapter.clear
puts 'Should be nil: ' + foo_adapter.get('a').inspect

