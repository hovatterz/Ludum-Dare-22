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
  attr_reader :health, :position, :symbol

  def initialize(hitDie='1d6', symbol='?')
    @health = RNG.roll(hitDie)
    @symbol = symbol
    @position = Point.new
  end
  
  # Offsets the creture by point
  def move(point)
    @position += point
  end

  def take_turn
  end

  # Moves the creature to point
  def teleport(point)
    @position = point
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

def render_game(game_win, player, dungeon)
  half_win_width  = (game_win.maxx / 2).round
  half_win_height = (game_win.maxy / 2).round
  center          = player.position

  i = 0 # cols
  j = 0 # rows
  ((center.x - half_win_width)..(center.x + half_win_width)).each do |x|
    ((center.y - half_win_height)..(center.y + half_win_height)).each do |y|
      tile = dungeon.tile_at(x, y)
      symbol = (tile == nil) ? '?' : tile.symbol
      putch(game_win, j, i, symbol)

      j += 1
    end

    i += 1
    j = 0
  end

  putch(game_win, half_win_height, half_win_width, player.symbol)

  game_win.noutrefresh
end

def render_hud(hud_win, turn)
  putstr(hud_win, 1, 1, "Turn: #{turn}")

  hud_win.noutrefresh
end

init_screen do |screen_width, screen_height|
  DUNGEON_WIDTH  = 10
  DUNGEON_HEIGHT = 10
  DUNGEON_FLOORS = 2

  # TODO: figure out if i should close these
  game_win = Curses.stdscr.subwin(screen_height - 2, screen_width - 20, 
                                  0, 0)

  hud_win = Curses.stdscr.subwin(screen_height - 2, 20, 
                                    0, screen_width - 20)

  player = Player.new
  player.teleport(Point.new(5, 5))

  dungeon = Dungeon.new(DUNGEON_WIDTH, DUNGEON_HEIGHT, DUNGEON_FLOORS)
  
  game_running = true
  turn = 1
  while game_running do
    render_game(game_win, player, dungeon)
    render_hud(hud_win, turn)
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
