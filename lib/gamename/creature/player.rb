class GameName
  class Creature
    class Player < Creature
      def initialize(dungeon)
        super(dungeon, '1d8')

        @symbol = '@'
        @name = 'Player'

        @inventory.add_item(Item::Potion.new)
      end

      def heal(points, announce=false)
        super(points)

        if announce
          GameName.announcements.push("You are healed for #{points} points!")
        end
      end

      def name
        @name
      end

      def attack(creature)
        test = super(creature)

        GameName.announcements.push("You attack a #{creature.name} for #{test} damage!")
      end

      def inflict(who, damage)
        super(who, damage)
        GameName.announcements.push("You are hit by a #{who.name} for #{damage} damage!")
      end
    
      # handles the players turn
      def take_turn(key)
        case key
          # Movement
        when Curses::Key::LEFT, ?h then return move(Point.new(-1, 0))
        when Curses::Key::RIGHT, ?l then return move(Point.new(1, 0))
        when Curses::Key::UP, ?k then return move(Point.new(0, -1))
        when Curses::Key::DOWN, ?j then return move(Point.new(0, 1))
        when ?y then return move(Point.new(-1, -1))
        when ?u then return move(Point.new(1, -1))
        when ?b then return move(Point.new(-1, 1))
        when ?n then return move(Point.new(1, 1))
          # Items
        when ?U then return use_item
          # Misc
        when ?.                     then return true
        else return false
        end

        true
      end

      private

      def use_item
        key = Curses.getch
        if @inventory.items[key]
          @inventory.remove_item(key).use(self)
          return true
        end

        false
      end
    end
  end
end

