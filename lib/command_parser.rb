require('stringio')

module TurtleTracks
  class CommandParser
    
    def initialize(input)
      @input = input
      @commands = Commands.new
    end
    
    def parse()
      enum = @input.each_line.collect(&:strip).reject(&:empty?) 
      return enum.collect { | line | @commands.parse_line(line) }
    end
    
  end
  
  class Commands
    def initialize()
      @matcher = {
        /^(\d+)$/ => lambda { | amount | command(:init_canvas, amount) },
        /^FD\s+(\d+)$/ => lambda { | amount | command(:move_forward, amount) },
        /^BK\s+(\d+)$/ => lambda { | amount | command(:move_backward, amount) },
        /^LT\s+(\d+)$/ => lambda { | amount | command(:rotate_counter, amount) },
        /^RT\s+(\d+)$/ => lambda { | amount | command(:rotate_clockwise, amount) },
        /^REPEAT\s+(\d+)\s+\[([^\]]+)\]$/ => lambda { | times, commands | repeat(times, commands) }
      }
    end
    
    def parse_line(line)
      @matcher.each do | reg_exp, action |
        match = line.match(reg_exp)
        return action.call(*match[1..-1]) unless match.nil?
      end
      raise "Bad command: #{line}"
    end
    
    def command(method_sym, input)
      amount = input.to_i
      lambda { | turtle | turtle.send(method_sym, amount) }
    end
    
    def repeat(iter, input)
      commands = input.scan(/\w+\s+\w+/).collect { | line | parse_line(line) }
      amount = iter.to_i
      lambda { | turtle| amount.times { commands.each { | command | command.call(turtle) } } }
    end

  end
end