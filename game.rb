#!/usr/bin/env ruby
# $:.unshift File.join(File.dirname(__FILE__), 'lib')
# require 'somegame'
require 'curses'

# Make shit work first
# Refactor later

class Point
  attr_accessor :x, :y

  def initialize(x=0,y=0)
    @x = x
    @y = y
  end
end

class RNG
  def self.roll(die)
    # TODO: refactor this shit somehow
    parts = die.split('d')
    result = 0
    parts[0].to_i.times { result += Random.rand(1..parts[1].to_i) }
    result
  end
end

class DungeonTile
  attr_reader :name, :passable, :symbol

  # pass a :symbol for type
  def initialize(type)
    case type
    when :wall
      @name = 'wall'
      @passable = false
      @symbol = '#'
    when :floor
      @name = 'floor'
      @passable = true
      @symbol = '.'
    end
  end
end

class DungeonFloor
  def initialize(width, height)
    @width = width
    @height = height
    @tiles = Array.new(width * height)
  end

  def generate!
    @width.times do |x|
      @height.times do |y|
        type = :floor
        if x == 0 or x == @width - 1 or y == 0 or y == @height - 1
          type = :wall
        end

        @tiles[y * @width + x] = DungeonTile.new(type)
      end
    end
  end
  
  def tile_at(x, y)
    @tiles[y * @width + x]
  end
end

class Dungeon
  def initialize(width, height, floors)
    @floors = Array.new
    floors.times do
      floor = DungeonFloor.new(width, height)
      floor.generate!
      @floors << floor
    end

    @current_floor = @floors.first
  end

  def tile_at(x, y)
    @current_floor.tile_at(x, y)
  end
end

class Creature
  attr_reader :health, :symbol

  def initialize(hitDie='1d6', symbol='?')
    @health = RNG.roll(hitDie)
    @symbol = symbol
  end

  def take_turn
  end
end

class Player < Creature
  def initialize
    super('1d8', '@')
  end

  def take_turn(key)
    case key
    when ?. then return true
    end
  end
end

# TODO: Need to think of better enemies
class Goblin < Creature
  def initialize
    super('1d6')
  end
end

# Writes a character at y, x
def putch(window, row, column, char)
  window.setpos(row, column)
  window.addch(char)
end

# Writes a string at y, x
def putstr(window, row, column, string)
  window.setpos(row, column)
  window.addstr(string)
end

MIN_WIDTH  = 80
MIN_HEIGHT = 40

def init_screen
  Curses.init_screen
  Curses.noecho
  Curses.stdscr.keypad(1)
  Curses.curs_set(0)

  while Curses.cols < MIN_WIDTH or Curses.lines < MIN_HEIGHT
    # fffffuuuuuuuuuuu line length > 80
    putstr(Curses.stdscr, 3, 5, 
           "Please adjust your console to at least #{MIN_WIDTH}x#{MIN_HEIGHT}")
    Curses.stdscr.refresh
  end

  begin
    yield(Curses.cols, Curses.lines)
  ensure
    Curses.close_screen
  end
end

init_screen do |screen_width, screen_height|
  # TODO: figure out if i should close these
  game_win = Curses.stdscr.subwin(screen_height - 2, screen_width - 20, 
                                  0, 0)

  hud_win = Curses.stdscr.subwin(screen_height - 2, 20, 
                                    0, screen_width - 20)

  DUNGEON_WIDTH  = 100
  DUNGEON_HEIGHT = 100
  DUNGEON_FLOORS = 2

  player = Player.new
  dungeon = Dungeon.new(DUNGEON_WIDTH, DUNGEON_HEIGHT, DUNGEON_FLOORS)
  
  game_running = true
  turn = 1
  while game_running do
    DUNGEON_WIDTH.times do |x|
      DUNGEON_HEIGHT.times do |y|
        putch(game_win, y, x, dungeon.tile_at(x, y).symbol)
      end
    end

    putstr(hud_win, 1, 1, "Turn: #{turn}")

    game_win.noutrefresh
    hud_win.noutrefresh
    Curses.refresh
    
    turn_taken = false
    turn += 1
    until turn_taken
      input = Curses.getch

      case input
      when ?Q then # quit game
        game_running = false
        turn_taken = true
      else 
        turn_taken = true if player.take_turn(input) # player takes turn
      end
    end

    #insert logic here
  end
end
