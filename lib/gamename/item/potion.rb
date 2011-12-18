class GameName
  class Item
    class Potion < Item
      def initialize
        @name = 'health potion'
      end

      def use(user)
        GameName.announcements.push("Your drink your #{@name}...")
        user.heal(GameName::RNG.roll('1d8'), true)
      end
    end
  end
end

