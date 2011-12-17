class GameName::RNG
  def self.roll(die)
    parts = die.split('d')
    result = 0
    parts[0].to_i.times { result += Random.rand(1..parts[1].to_i) }
    result
  end

  def self.rand_point_in_rect(rect)
    GameName::Point.new(Random.rand((rect.x + 1)..rect.x2), Random.rand((rect.y + 1)..rect.y2))
  end
end
