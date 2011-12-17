class GameName
  class Creature
    class InsuranceSalesman < Creature
      def initialize(dungeon)
        super(dungeon, '2d6')

        @symbol = 'i'
        @name = 'Insurance Salesman'
      end
    end
  end
end
