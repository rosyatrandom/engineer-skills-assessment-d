require_relative 'lib\counter\counter'
require_relative 'lib\counter\counter_cli'
require_relative 'lib\cli'

include Counter

if CLI.running_from_cli? __FILE__
  CLICodeLineCounter.new.run
else
  CodeLineCounter
end