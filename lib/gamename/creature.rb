class GameName
  class Creature
    ADJECTIVES = ['rabid', 'horrifying', 'hideous', 'intimidating', 
                  'outrageous', 'terrifying', 'daunting', 'delightful',
                   'fabulous', 'disgusting', 'appalling', 'chilling']

    attr_reader :decay, :health, :position

    # Initialize with the dungeon and a hitDie string
    def initialize(dungeon, hitDie='1d6')
      @dungeon = dungeon
      @health = RNG.roll(hitDie)
      @position = Point.new
  
      @adjective = ADJECTIVES.shuffle.first
      @decay = 0
      @name = 'Shapeless Beast'
      @symbol = '?'
    end

    def alive?
      @health > 0
    end

    # Attacks another creature
    def attack(other_creature)
      other_creature.inflict(500)
    end

    # Inflicts damage upon this creature
    def inflict(damage)
      @health -= damage
    end
    
    # Offsets the creture by point
    def move(point)
      new_point = @position + point
      tile = @dungeon.tile_at(new_point)
      if tile.creature and tile.creature.alive?
        attack(tile.creature)
      else
        @position = new_point if tile.passable?
      end
    end

    def name
      "#{@adjective} #{@name}"
    end

    def symbol
      if alive?
        @symbol
      else
        'X'
      end
    end

    def take_turn
      unless alive?
        @decay += 1
      end
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

