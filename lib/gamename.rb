require 'curses'

class GameName
  attr_reader :dungeon, :player, :turn

  def initialize
    @running = true
    @turn = 1
  end

  def generate_dungeon(width, height, floors)
    @dungeon = Dungeon.new(width, height, floors)

    @player = Creature::Player.new(@dungeon)
    @player.teleport(Point.new(5, 5))
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
  end

  # Returns the center of view
  def view_position
    @player.position
  end
end

require 'gamename/point'
require 'gamename/rng'
require 'gamename/creature'
require 'gamename/dungeon'
