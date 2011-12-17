class GameName::Creature::Player < GameName::Creature
  def initialize(dungeon)
    super(dungeon, '1d8', '@')
  end

  def take_turn(key)
    case key
    when Curses::Key::LEFT then move(GameName::Point.new(-1, 0))
    when Curses::Key::RIGHT then move(GameName::Point.new(1, 0))
    when Curses::Key::UP then move(GameName::Point.new(0, -1))
    when Curses::Key::DOWN then move(GameName::Point.new(0, 1))
    when ?. then return true
    else return false
    end

    true
  end
end
