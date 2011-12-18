class GameName
  class Dungeon
    ROOM_TYPES = [
      { :name  => 'Boy Band Practice Room', 
        :range => 1..3,
        :creatures => { 
          :types => [Creature::BoyBandMember], 
          :range => 2..4 } },
      { :name  => 'Insurance Call Center',
        :range => 1..4,
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

    attr_reader :height, :width

    def generate!(width, height, floors, player)
      @width = width
      @height = height
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

      @floors.each_with_index do |floor, i|
        break if i == @floors.length - 1

        5.times do |x|
          staircase_placed = false
          until staircase_placed
            rand_point = Point.new(Random.rand(1..@width), Random.rand(1..@height))
            if floor.tile_at(rand_point).type == :floor and @floors[i + 1].tile_at(rand_point).type == :floor
              floor.tile_at(rand_point).mutate!(:down_stairs)
              @floors[i + 1].tile_at(rand_point).mutate!(:up_stairs)
              staircase_placed = true
            end
          end
        end
      end

      @current_floor = @floors.first
      @player.teleport(@current_floor.player_start)
    end

    def change_floor(modifier)
      @current_floor = @floors[@floors.index(@current_floor) + modifier]
    end

    def creatures
      @current_floor.creatures
    end

    def darken
      @width.times do |x|
        @height.times do |y|
          @current_floor.tile_at(Point.new(x, y)).lit = false
        end
      end
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

