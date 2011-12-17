class GameName::Dungeon::Floor
  def initialize(width, height)
    @width = width
    @height = height
    @tiles = Array.new(width) { Array.new(height) }
  end

  def generate!
    @width.times do |x|
      @height.times do |y|
        if x == 0 or x == @width - 1 or y == 0 or y == @height - 1
          type = :wall
        else
          type = (GameName::RNG.roll('1d2') % 2 == 0) ? :floor : :wall
        end

        @tiles[x][y] = GameName::Dungeon::Tile.new(type)
      end
    end
  end
  
  def tile_at(point)
    @tiles[point.x][point.y] unless point.x < 0 or point.y < 0 or 
                                    point.x >= @width or point.y >= @height
  end
end
