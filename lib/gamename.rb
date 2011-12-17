require 'curses'

class GameName
  attr_reader :dungeon, :player, :turn

  def initialize
    @running = true
    @turn = 1
  end

  def generate_dungeon(width, height, floors)
    @dungeon = Dungeon.new()
    @player = Creature::Player.new(@dungeon)
    @dungeon.generate!(width, height, floors, @player)
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
        turn_taken = true if player.take_turn(input) # player takes turn
      end
    end
    
    @turn += 1
  end

  def running?
    @running
  end

  # Handles game logic
  def think
    @dungeon.creatures.each do |c|
      c.take_turn
      if c.decay > 20 #corpse decay on the 20th turn
        @dungeon.tile_at(c.position).creature = nil
        @dungeon.creatures.delete(c)
      end
    end
  end

  # Returns the center of view
  def view_position
    @player.position
  end
end

require 'gamename/point'
require 'gamename/rect'
require 'gamename/rng'
require 'gamename/creature'
require 'gamename/dungeon'
