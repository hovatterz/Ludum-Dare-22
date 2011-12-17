class GameName
  class Inventory
    attr_reader :items

    def initialize
      @items = Hash.new
    end

    # Adds the item to the hash
    def add_item(item)
      ('a'..'z').each do |key|
        unless @items[key]
          @items[key] = item
          break
        end
      end
    end

    # Removes the item from the hash and returns it
    def remove_item(key)
      item = @items[key]
      @items[key] = nil
      item
    end
  end
end

