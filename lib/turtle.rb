require_relative('canvas')

module TurtleTracks
  class Turtle
    def initialize
      @direction = 0
      @dir_mapping = {
        0 => [0,-1],
        45 => [1,-1],
        90 => [1,0],
        135 => [1,1],
        180 => [0,1],
        225 => [-1,1],
        270 => [-1,0],
        315 => [-1,-1]
      }
      @dir_mapping.default_proc = proc { raise "incorrect direction: #{@direction}" }
    end
    
    def init_canvas(size)
      @canvas = Canvas.new(size)
      @x = @y = size / 2
      @canvas.turn_on(@x,@y)
    end
    
    def move_forward(amount)
      move(amount, :+)
    end
    
    def move_backward(amount)
      move(amount, :-)
    end
    
    def move(amount, polarity)
      byX, byY = translate_direction
      amount.times do
        @x, @y = @x.send(polarity,byX), @y.send(polarity, byY)
        @canvas.turn_on(@x,@y)
      end
    end
    
    def translate_direction
      @dir_mapping[@direction]
    end
    
    def rotate_clockwise(degrees)
      @direction += degrees
      @direction = @direction % 360
    end
    
    def rotate_counter(degrees)
      rotate_clockwise(-degrees)
    end
    
    def to_s
      @canvas.to_s
    end
    
  end
end