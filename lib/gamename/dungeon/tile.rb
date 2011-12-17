class GameName
  class Dungeon
    class Tile
      attr_accessor :creature
      attr_reader :name, :passable

      # pass a :symbol for type
      def initialize(type)
        set_type(type)
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

