class GameName
  class Creature
    class Player < Creature
      def initialize(dungeon)
        super(dungeon, '1d8', '@')
      end
    
      # handles the players turn
      def take_turn(key)
        case key
        when Curses::Key::LEFT, ?h then move(Point.new(-1, 0))
        when Curses::Key::RIGHT, ?l then move(Point.new(1, 0))
        when Curses::Key::UP, ?k then move(Point.new(0, -1))
        when Curses::Key::DOWN, ?j then move(Point.new(0, 1))
        when ?y then move(Point.new(-1, -1))
        when ?u then move(Point.new(1, -1))
        when ?b then move(Point.new(-1, 1))
        when ?n then move(Point.new(1, 1))
        when ?. then return true
        else return false
        end

        true
      end
    end
  end
end

