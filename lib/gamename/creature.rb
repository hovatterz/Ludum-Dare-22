class GameName
  class Creature
    attr_reader :health, :position, :symbol

    # Initialize with the dungeon, a hitDie string, and a symbol
    def initialize(dungeon, hitDie='1d6', symbol='?')
      @dungeon = dungeon
      @health = RNG.roll(hitDie)
      @symbol = symbol
      @position = Point.new
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
end

require 'gamename/creature/player'

