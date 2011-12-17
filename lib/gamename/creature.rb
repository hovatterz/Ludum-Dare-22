class GameName::Creature
  attr_reader :health, :position, :symbol

  def initialize(dungeon, hitDie='1d6', symbol='?')
    @dungeon = dungeon
    @health = GameName::RNG.roll(hitDie)
    @symbol = symbol
    @position = GameName::Point.new
  end
  
  # Offsets the creture by point
  def move(point)
    new_point = @position + point
    @position = new_point if @dungeon.tile_at(new_point).passable
  end

  def take_turn
  end

  # Moves the creature to point
  def teleport(point)
    @position = point
  end
end

require 'gamename/creature/player'

