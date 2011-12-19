require 'curses'

class GameName
  attr_reader :dungeon, :fov, :player, :turn
  @@announcements = []

  def initialize
    @running = true
    @turn = 1
  end

  def generate_dungeon(width, height, floors)
    @dungeon = Dungeon.new
    @player = Creature::Player.new(@dungeon)
    @dungeon.generate!(width, height, floors, @player)
    @fov = FOV.new(@dungeon)
    @over = false
  end

  def handle_input()
    turn_taken = false
    until turn_taken
      input = Curses.getch
      case input
      when ?Q then # quit game
         @running = false
         turn_taken = true
      else
        turn_taken = true if @player.take_turn(input) # player takes turn
      end
    end
    
    @turn += 1
  end

  def over?
    @over
  end

  def running?
    @running
  end

  # Handles game logic
  def think
    @dungeon.creatures.each do |c|
      if c.alive?
        c.take_turn(@player)
      else
        player.award_exp(c.exp_yield)

        tile = @dungeon.tile_at(c.position)
        tile.creature = nil
        @dungeon.creatures.delete(c)

        tile.items.push(Item::Potion.new) if RNG.roll('1d6') == 3
      end
    end

    @over = true unless player.alive?
    
    @dungeon.darken
    @fov.calculate(@player.position, 10)

    if turn % 5 == 0
      @player.heal(1)
    end
  end

  # Returns the center of view
  def view_position
    @player.position
  end

  def self.announcements
    @@announcements
  end
end

require 'gamename/point'
require 'gamename/rect'
require 'gamename/rng'
require 'gamename/astarnode'
require 'gamename/fov'
require 'gamename/inventory'
require 'gamename/item'
require 'gamename/creature'
require 'gamename/dungeon'

