class GameName
  class Creature
    class BoyBandMember < Creature
      # Wikipedia'd these. I definitely didn't know them
      NAMES = ['A.J. McLean', 'Howie Dorough', 'Brian Littrell', 
                'Nick Carter', 'Kevin Richardson', 'JC Chasez', 
                'Justin Timberlake', 'Lance Bass', 'Joey Fatone',
                'Chris Kirkpatrick']

      def initialize(dungeon)
        super(dungeon, '1d4')

        @symbol = 'b'
        @name = NAMES.shuffle.first
      end
    end
  end
end
