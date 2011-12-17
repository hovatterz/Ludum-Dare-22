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
    num_dice = parts[0].to_i
    sides = parts[1].to_i
    result = 0

    num_dice.times { result += Random.rand(1..sides) }
    result
  end
end

class Creature
  attr_reader :health

  def initialize(hitDie='1d6')
    @health = RNG.roll(hitDie)
  end

  def take_turn
  end
end

class Player < Creature
  def initialize
    super('1d8')
  end

  def take_turn(key)
    case key
      case ?. then break # skip turn
      end
    end
  end
end

# TODO: Need to think of better enemies
class Goblin < Creature

end

def init_screen
  Curses.init_screen
  Curses.noecho
  Curses.stdscr.keypad(1)
  Curses.curs_set(0)

  begin
    yield
  ensure
    Curses.close_screen
  end
end

init_screen do
  player = Player.new

  loop do
    input = Curses.getch
    case input
    when ?q then break # quit game  
    else player.take_turn(input) # player takes turn
    end
  end
end
