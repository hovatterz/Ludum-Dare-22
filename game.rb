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
    parts = die.split('d')
    num_dice = parts[0].to_i
    sides = parts[1].to_i
    result = 0

    num_dice.times { result += Random.rand(1..sides) }
    result
  end
end

puts RNG.roll('1d6')

class Creature
  def initialize
  end
end

class Player < Creature
  def initialize
    super
  end
end

# Need to think of better enemies
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

# init_screen do
#  loop do
#    case Curses.getch
#    when ?q then break
#    end
#  end
#end
