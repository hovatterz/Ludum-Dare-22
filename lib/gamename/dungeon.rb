class GameName
  class Dungeon
    def generate!(width, height, floors, player)
      @player = player

      @floors = Array.new
      floors.times do
        floor = Floor.new(self, width, height)
        floor.generate!
        @floors << floor
      end

      @current_floor = @floors.first
      @player.teleport(@current_floor.player_start)
    end

    def tile_at(point)
      @current_floor.tile_at(point)
    end
  end
end

require 'gamename/dungeon/tile'
require 'gamename/dungeon/floor'

