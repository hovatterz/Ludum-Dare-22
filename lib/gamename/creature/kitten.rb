class GameName
  class Creature
    class Kitten < Creature
      def initialize(dungeon)
        super(dungeon, '10d100')
        @exp_yield = 9001
        @symbol = 'k'
        @name = 'Kitten'
      end

      def take_turn(player)
      end
    end
  end
end

