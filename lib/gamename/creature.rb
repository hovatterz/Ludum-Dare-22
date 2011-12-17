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

    # Offsets the creature by point
    def move(point, attack=true)
      new_point = @position + point
      tile = @dungeon.tile_at(new_point)
      if tile.passable?
        @dungeon.tile_at(position).creature = nil
        @position = new_point
        tile.creature = self
      elsif attack and tile.creature and tile.creature.alive?
        attack(tile.creature)
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
      if alive?
        ai_wander
      else
        @decay += 1
      end
    end

    # Moves the creature to point
    def teleport(point)
      @position = point
    end

    private

    # causes the creature to wander randomly
    def ai_wander
      moved = false
      tries = 0
      until moved
        rand_offset = Point.new(Random.rand(-1..1), Random.rand(-1..1))
        moved = true if move(rand_offset, false)
        tries += 1
        break if tries > 3 # let prevent an infinite loop in case they get stuck
      end
    end
  end
end

require 'gamename/creature/player'
require 'gamename/creature/boybandmember'
require 'gamename/creature/insurancesalesman'
require 'gamename/creature/mechanic'
require 'gamename/creature/boss'

