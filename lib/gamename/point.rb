class GameName::Point
  attr_accessor :x, :y

  def initialize(x=0,y=0)
    @x = x
    @y = y
  end

  def +(point)
    GameName::Point.new(@x + point.x, @y + point.y)
  end
end

