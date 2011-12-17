# I should probably move this somewhere else
class Rect
  attr_accessor :x, :y, :x2, :y2

  def initialize(x, y, width, height)
    @x = x
    @y = y
    @x2 = x + width
    @y2 = y + height
  end

  def center
    GameName::Point.new((@x + @x2) / 2, (@y + @y2) / 2)
  end

  def intersects?(other)
    @x <= other.x + other.x2 and @x2 >= other.x and
    @y <= other.y + other.y2 and @y2 >= other.y
  end
end

class GameName::Dungeon::Floor
  ROOM_MAX_SIZE = 20
  ROOM_MIN_SIZE = 6
  MAX_ROOMS     = 100

  def initialize(width, height)
    @width = width
    @height = height
    @tiles = Array.new(width) { Array.new(height) }
  end

  def generate!
    @width.times do |x|
      @height.times do |y|
        @tiles[x][y] = GameName::Dungeon::Tile.new(:wall)
      end
    end

    rooms = Array.new
    MAX_ROOMS.times do |r|
      w = Random.rand(ROOM_MIN_SIZE..ROOM_MAX_SIZE)
      h = Random.rand(ROOM_MIN_SIZE..ROOM_MAX_SIZE)
      x = Random.rand(0..(@width - w - 1))
      y = Random.rand(0..(@height - h - 1))

      new_room = Rect.new(x, y, w, h)

      failed = false
      rooms.each do |other_room|
        if new_room.intersects?(other_room)
          failed = true
          break
        end
      end

      unless failed
        create_room(new_room)
        new_center = new_room.center

        unless rooms.empty?
          old_center = rooms.last.center
          if Random.rand(0..1) == 1
            # first move horizontally, then vertically
            create_h_tunnel(old_center.x, new_center.x, old_center.y)
            create_v_tunnel(old_center.y, new_center.y, new_center.x)
          else
            # first move vertically, then horizontally
            create_v_tunnel(old_center.y, new_center.y, old_center.x)
            create_h_tunnel(old_center.x, new_center.x, new_center.y)
          end
        end

        rooms << new_room
      end
    end
  end
  
  def tile_at(point)
    @tiles[point.x][point.y] unless point.x < 0 or point.y < 0 or 
                                    point.x >= @width or point.y >= @height
  end

  private

  # Carves out a room
  def create_room(rect)
    x_min = rect.x + 1
    x_max = rect.x2
    y_min = rect.y + 1
    y_max = rect.y2

    (x_min..x_max).each do |x|
      (y_min..y_max).each do |y|
        @tiles[x][y].mutate!(:floor)
      end
    end
  end

  # Creates a horizontal tunnel
  def create_h_tunnel(x, x2, y)
    min = [x, x2].min
    max = [x, x2].max

    (min..max).each do |x|
      @tiles[x][y].mutate!(:floor)
    end
  end

  # Creates a vertical tunnel
  def create_v_tunnel(y, y2, x)
    min = [y, y2].min
    max = [y, y2].max

    (min..max).each do |y|
      @tiles[x][y].mutate!(:floor)
    end
  end
end
