class GameName
  class Creature
    class InsuranceSalesman < Creature
      def initialize(dungeon)
        super(dungeon, '1d6')

        @symbol = 'i'
        @name = 'Insurance Salesman'
      end
    end
  end
end

