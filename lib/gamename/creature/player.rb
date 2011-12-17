class GameName::Creature::Player < GameName::Creature
  def initialize(dungeon)
    super(dungeon, '1d8', '@')
  end

  def take_turn(key)
    case key
    when Curses::Key::LEFT, ?h then move(GameName::Point.new(-1, 0))
    when Curses::Key::RIGHT, ?l then move(GameName::Point.new(1, 0))
    when Curses::Key::UP, ?k then move(GameName::Point.new(0, -1))
    when Curses::Key::DOWN, ?j then move(GameName::Point.new(0, 1))
    when ?y then move(GameName::Point.new(-1, -1))
    when ?u then move(GameName::Point.new(1, -1))
    when ?b then move(GameName::Point.new(-1, 1))
    when ?n then move(GameName::Point.new(1, 1))
    when ?. then return true
    else return false
    end

    true
  end
end
