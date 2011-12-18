class GameName
  class Item
    attr_reader :name

    def initialize
      @name = 'Shapeless Item'
    end

    def use(user)
      GameName.announcements.push('You can\'t use that!')
    end

    def equip
      GameName.announcements.push('You can\'t equip that!')
    end

    def to_s
      @name
    end
  end
end

require 'gamename/item/potion'

