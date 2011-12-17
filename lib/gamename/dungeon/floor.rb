class GameName
  class Dungeon
    class Floor
      ROOM_MAX_SIZE = 20
      ROOM_MIN_SIZE = 6
      MAX_ROOMS     = 100

      attr_reader :player_start

      def initialize(dungeon, width, height)
        @width = width
        @height = height

        @tiles = Array.new(width) { Array.new(height) }
        @rooms = {}
      end

      def generate!(room_types)
        @width.times do |x|
          @height.times do |y|
            @tiles[x][y] = {}
            @tiles[x][y][:tile] = Tile.new(:wall)
          end
        end

        last_rect = nil
        MAX_ROOMS.times do |r|
          w = Random.rand(ROOM_MIN_SIZE..ROOM_MAX_SIZE)
          h = Random.rand(ROOM_MIN_SIZE..ROOM_MAX_SIZE)
          x = Random.rand(0..(@width - w - 1))
          y = Random.rand(0..(@height - h - 1))

          new_room = {}
          new_room[:rect] = Rect.new(x, y, w, h)

          failed = false
          @rooms.each do |other_rect, other_room|
            if new_room[:rect].intersects?(other_rect)
              failed = true
              break
            end
          end

          unless failed
            create_room(new_room[:rect])
            new_center = new_room[:rect].center

            if @rooms.empty?
              @player_start = new_center
            else
              old_center = last_rect.center
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
            
            until new_room[:type]
              type = room_types.shuffle.first
              length = @rooms.select {|rect, room| room[:type] == type }.length
              unless type[:limit] and type[:limit] > length
                new_room[:type] = type
              end
            end

            @rooms[new_room[:rect]] = new_room
            last_rect = new_room[:rect]
          end
        end
      end

      # Returns a hash of room data at a point
      def room_at(point)
        room = @rooms.select {|rect, room| rect.contains?(point) }
        room = room.flatten.last
        if room
          room[:type]
        end
      end
  
      # Returns a tile at a point
      def tile_at(point)
        if point.x > 0 and point.y > 0 and 
           point.x < @width and point.y < @height
          return @tiles[point.x][point.y][:tile]
        end

        Tile.new(:wall)
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
            @tiles[x][y][:tile].mutate!(:floor)
          end
        end
      end

      # Creates a horizontal tunnel
      def create_h_tunnel(x, x2, y)
        min = [x, x2].min
        max = [x, x2].max

        (min..max).each do |x|
          @tiles[x][y][:tile].mutate!(:floor)
        end
      end

      # Creates a vertical tunnel
      def create_v_tunnel(y, y2, x)
        min = [y, y2].min
        max = [y, y2].max

        (min..max).each do |y|
          @tiles[x][y][:tile].mutate!(:floor)
        end
      end
    end
  end
end

