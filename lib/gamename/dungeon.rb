class GameName::Dungeon
  def initialize(width, height, floors)
    @floors = Array.new
    floors.times do
      floor = Floor.new(width, height)
      floor.generate!
      @floors << floor
    end

    @current_floor = @floors.first
  end

  def tile_at(point)
    @current_floor.tile_at(point)
  end
end

require 'gamename/dungeon/tile'
require 'gamename/dungeon/floor'
