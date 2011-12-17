class GameName
  class Dungeon
    ROOM_TYPES = [
      { :name  => 'Boy Band Practice Room', 
        :range => 1..3,
        :creatures => { 
          :types => [Creature::BoyBandMember], 
          :range => 2..4 } },
      { :name  => 'Insurance Call Center',
        :range => 2..4,
        :creatures => { 
          :types => [Creature::InsuranceSalesman], 
          :range => 3..5 } },
      { :name  => 'Auto Mechanic Shop',
        :range => 3..4,
        :creatures => { 
          :types => [Creature::Mechanic], 
          :range => 2..3 } },
      { :name  => 'R\'lyeh',
        :range => 5..5,
        :limit => 1 }
    ]

    def generate!(width, height, floors, player)
      @player = player

      @floors = Array.new
      floors.times do |i|
        room_types = Array.new
        ROOM_TYPES.each do |type|
          if type[:range].include?(i + 1)
            room_types << type
          end
        end

        floor = Floor.new(self, width, height)
        floor.generate!(room_types)
        @floors << floor
      end

      @current_floor = @floors.first
      @player.teleport(@current_floor.player_start)
    end

    def room_at(point)
      @current_floor.room_at(point)
    end

    def tile_at(point)
      @current_floor.tile_at(point)
    end
  end
end

require 'gamename/dungeon/tile'
require 'gamename/dungeon/floor'

