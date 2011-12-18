class GameName
  class Creature
    ADJECTIVES = ['rabid', 'horrifying', 'hideous', 'intimidating', 
                  'outrageous', 'terrifying', 'daunting', 'delightful',
                   'fabulous', 'disgusting', 'appalling', 'chilling']

    attr_reader :decay, :health, :position

    # Initialize with the dungeon and a hitDie string
    def initialize(dungeon, hit_die='1d6', unarmed_damage='1d2')
      @dungeon = dungeon
      @hit_die = hit_die
      @unarmed_damage = unarmed_damage

      @position = Point.new
      @health = RNG.roll(@hit_die)
      @adjective = ADJECTIVES.shuffle.first
      @decay = 0
      @name = 'Shapeless Beast'
      @symbol = '?'
      
      @has_been_seen = false
    end

    def alive?
      @health > 0
    end

    # Attacks another creature
    def attack(other_creature)
      damage = GameName::RNG.roll(@unarmed_damage)
      other_creature.inflict(self, damage)
      damage
    end

    # Inflicts damage upon this creature
    def inflict(who, damage)
      @health -= damage
    end

    # Offsets the creature by point
    def move(point, attack=true, absolute=false)
      if absolute
        new_point = point
        tile = @dungeon.tile_at(new_point)
      else
        new_point = @position + point
        tile = @dungeon.tile_at(new_point)
      end

      if tile.creature and tile.creature.class != self.class and tile.creature.alive?
        attack(tile.creature)
        return true
      elsif tile.passable
        @dungeon.tile_at(@position).creature = nil
        @position = new_point
        tile.creature = self
        return true
      end

      false
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

    def take_turn(player)
      if alive?
        if @has_been_seen or @dungeon.tile_at(@position).lit
          ai_chase(player)
        else
          ai_wander
        end

        if !@has_been_seen and @dungeon.tile_at(@position).lit
          @has_been_seen = true
        end
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
        break if tries > 2 # let prevent an infinite loop in case they get stuck
      end
    end

    def ai_chase(entity)
      nodes ||= @dungeon.tile_at(@position).path_to(@dungeon.tile_at(entity.position))[1]
      if nodes and nodes.length > 1
        nodes.shift
        move(nodes[0].position, true, true)
      end
    end
  end
end

require 'gamename/creature/player'
require 'gamename/creature/boybandmember'
require 'gamename/creature/insurancesalesman'
require 'gamename/creature/mechanic'
require 'gamename/creature/boss'

