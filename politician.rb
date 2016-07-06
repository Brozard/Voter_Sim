# require "./person.rb"

class Politician < Person
  @@num_of_politicians = 0
  attr_accessor :party

  def initialize(name, party)
    super(name)
    @party = party
    @@num_of_politicians += 1
  end

  def self.politician_count
    @@num_of_politicians
  end
end

# p Politician.politician_count
# p Person.people_count

# pol1 = Politician.new("me", "Democrat")

# p Politician.politician_count
# p Person.people_count


# p pol1.person_id

# pol2 = Politician.new("you", "Democrat")

# p pol2.person_id

# p Politician.politician_count
# p Person.people_count