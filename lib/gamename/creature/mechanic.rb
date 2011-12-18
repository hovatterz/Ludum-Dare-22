class GameName
  class Creature
    class Mechanic < Creature
      def initialize(dungeon)
        super(dungeon, '2d6')

        @symbol = 'm'
        @name = 'Mechanic'
      end
    end
  end
end


