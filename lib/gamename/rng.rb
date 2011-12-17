class GameName::RNG
  def self.roll(die)
    # TODO: refactor this shit somehow
    parts = die.split('d')
    result = 0
    parts[0].to_i.times { result += Random.rand(1..parts[1].to_i) }
    result
  end
end
