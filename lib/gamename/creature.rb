class GameName
  class Creature
    ADJECTIVES = ['rabid', 'horrifying', 'hideous', 'intimidating', 
                  'outrageous', 'terrifying', 'daunting', 'delightful',
                   'fabulous', 'disgusting', 'appalling', 'chilling']

    attr_reader :health, :position, :symbol

    # Initialize with the dungeon and a hitDie string
    def initialize(dungeon, hitDie='1d6')
      @dungeon = dungeon
      @health = RNG.roll(hitDie)
      @position = Point.new
  
      @adjective = ADJECTIVES.shuffle.first
      @name = 'Shapeless Beast'
      @symbol = '?'
    end
    
    # Offsets the creture by point
    def move(point)
      new_point = @position + point
      @position = new_point if @dungeon.tile_at(new_point).passable
    end

    def name
      "#{@adjective} #{@name}"
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
require 'gamename/creature/boybandmember'
require 'gamename/creature/insurancesalesman'
require 'gamename/creature/mechanic'
require 'gamename/creature/boss'

