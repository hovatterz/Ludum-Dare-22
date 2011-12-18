class GameName
  class Dungeon
    class Tile < GameName::AStarNode
      attr_accessor :creature
      attr_reader :name, :position

      # pass a :symbol for type
      def initialize(type, dungeon, position)
        set_type(type)
        @dungeon = dungeon
        @position = position
      end

      def symbol
        if @creature
          @creature.symbol
        else
          @symbol
        end
      end

      # pass a :symbol for type
      def mutate!(type)
        set_type(type)
      end

      def hash
        (@position.x << 16) | @position.y
      end

      def passable?
        @passable
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
        result.delete_if {|node| node.passable? == false}
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
  end
end

