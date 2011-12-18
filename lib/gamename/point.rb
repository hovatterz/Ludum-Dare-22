class GameName::Point
  attr_accessor :x, :y

  def initialize(x=0,y=0)
    @x = x
    @y = y
  end

  def abs
    GameName::Point.new(@x.abs, @y.abs)
  end

  def distance_from(other)
    Math.sqrt((other.x - @x) ** 2 + (other.y - @y) ** 2)
  end

  def to_s
    "(#{@x}, #{@y})"
  end

  def +(other)
    GameName::Point.new(@x + other.x, @y + other.y)
  end

  def -(other)
    GameName::Point.new(@x - other.x, @y - other.y)
  end
end

