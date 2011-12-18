class GameName
  class Dungeon
    class Tile < GameName::AStarNode
      attr_accessor :creature, :items, :lit
      attr_reader :name, :passable, :position, :seen, :transparent

      # pass a :symbol for type
      def initialize(type, dungeon, position)
        set_type(type)
        @dungeon = dungeon
        @position = position
        @seen = false
      end

      def color
        return 5 if @creature
        @color
      end

      def symbol
        if @creature and @lit
          @creature.symbol
        else
          @symbol
        end
      end

      # pass a :symbol for type
      def mutate!(type)
        set_type(type)
      end

      def light
        @lit = true
        @seen = true
      end

      def neighbors
        result = [
          @dungeon.tile_at(@position + GameName::Point.new(0, -1)),
          @dungeon.tile_at(@position + GameName::Point.new(-1,  -1)),
          @dungeon.tile_at(@position + GameName::Point.new(1,  -1)),
          @dungeon.tile_at(@position + GameName::Point.new(0,  1)),
          @dungeon.tile_at(@position + GameName::Point.new(-1,  1)),
          @dungeon.tile_at(@position + GameName::Point.new(1,  1)),
          @dungeon.tile_at(@position + GameName::Point.new(-1, 0)),
          @dungeon.tile_at(@position + GameName::Point.new(1,  0))
        ]
        result.delete_if {|node| node.passable == false}
        result
      end

      def guess_distance(node)
        (@position.x - node.position.x).abs + (@position.y - node.position.y).abs
      end

      def movement_cost(neighbor)
        1
      end

      private

      # pass a :symbol for type
      def set_type(type)
        case type
        when :wall
          @color = 3
          @name = 'wall'
          @passable = false
          @symbol = '#'
          @transparent = false
        when :floor
          @color = 4
          @name = 'floor'
          @passable = true
          @symbol = '.'
          @transparent = true
        end
      end
    end
  end
end

