require_relative 'lib\code_line_counter\code_line_counter'
require_relative 'lib\code_line_counter\code_line_counter_cli'
require_relative 'lib\cli'

include CodeLineCounter

if CLI.running_from_cli? __FILE__
  CLICodeLineCounter.new.run
else
  CodeLineCounter
end