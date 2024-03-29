class GameName
  class Creature
    class Player < Creature
      attr_reader :experience, :level

      def initialize(dungeon)
        super(dungeon, '1d8')

        @experience = 0
        @level = 1
        @symbol = '@'
        @name = 'Player'

        @inventory.add_item(Item::Potion.new)
      end

      def award_exp(xp)
        @experience += xp
        tnl = next_level
        advance_level if @experience >= tnl
      end
      
      def get
        items = @dungeon.tile_at(@position).items
        if items.length > 0
          item = items.pop
          @inventory.add_item(item)
          GameName.announcements.push("You pick up a(n) #{item}.")
          return true
        else
          GameName.announcements.push('But there\'s nothing here...')
          return true #TODO make this not true
        end
      end

      def heal(points, announce=false)
        super(points)

        if announce
          GameName.announcements.push("You are healed for #{points} points!")
        end
      end

      def move(point, attack=true, absolute=false)
        moved = super(point, attack, absolute)
        
        if moved
          items = @dungeon.tile_at(@position).items
          if items.length > 0
            if items.length == 1
              GameName.announcements.push("There is a(n) #{items.to_s} here.")
            else
              GameName.announcements.push("There are some items (#{items.to_s}) here.")
            end
          end
        end
        moved
      end

      def name
        @name
      end

      def next_level
        ((level + 1) * 500)
      end

      def attack(creature)
        test = super(creature)

        GameName.announcements.push("You attack a #{creature.name} for #{test} damage!")
      end

      def inflict(who, damage)
        super(who, damage)
        GameName.announcements.push("You are hit by a #{who.name} for #{damage} damage!")
      end

      def traverse_level
        tile = @dungeon.tile_at(@position)
        if tile.type == :up_stairs
          @dungeon.change_floor(-1)
          return true
        end

        if tile.type == :down_stairs
          @dungeon.change_floor(1)
          return true
        end

        false
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
        when ?> then return traverse_level
        when ?< then return traverse_level
          # Items
        when ?U then return use_item
        when ?g then return get
          # Misc
        when ?.                     then return true
        else return false
        end

        true
      end

      private

      def advance_level
        @level += 1
        health_up = GameName::RNG.roll(@hit_die)
        @max_health += health_up
        @health += (health_up / 2).round

        dmg = @unarmed_damage.split('d')[1].to_i
        dmg += 2
        @unarmed_damage = "1d#{dmg}"
        GameName.announcements.push("You are now level #{@level}!")

        @experience = 0
      end

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

