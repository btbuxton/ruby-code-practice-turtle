require_relative('../lib/command_parser')
require_relative('../lib/turtle')
require 'benchmark'

time = Benchmark.realtime do
  ARGV.each do | input |
    open(input) do | io |
      parser = TurtleTracks::CommandParser.new(io)
      turtle = TurtleTracks::Turtle.new
      parser.parse.each { | each | each.call(turtle) }
      puts turtle.to_s
    end
  end
end
puts "Time elapsed #{time*1000} milliseconds"