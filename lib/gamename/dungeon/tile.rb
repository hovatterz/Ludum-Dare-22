class GameName
  class Dungeon
    class Tile < GameName::AStarNode
      attr_accessor :creature, :items, :lit
      attr_reader :name, :passable, :position, :seen, :transparent, :type

      # pass a :symbol for type
      def initialize(type, dungeon, position)
        set_type(type)
        
        @dungeon = dungeon
        @position = position
        @seen = false
        @items = Array.new
      end

      def color
        return 5 if @creature
        return 6 if @items.length > 0
        @color
      end

      def symbol
        if @creature and @lit
          @creature.symbol
        elsif @items.length > 0
          '%'
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
        @type = type

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
        when :down_stairs
          @color = 7
          @name = 'down stairs'
          @passable = true
          @symbol = '>'
          @transparent = true
        when :up_stairs
          @color = 7
          @name = 'up stairs'
          @passable = true
          @symbol = '<'
          @transparent = true
        end
      end
    end
  end
end

