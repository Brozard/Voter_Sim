# require "./person.rb"

class Voter < Person
  @@num_of_voters = 0
  attr_accessor :politics

  def initialize(name, politics)
    super(name)
    @politics = politics
    @@num_of_voters += 1
  end

  def self.voter_count
    @@num_of_voters
  end
end

# v = Voter.new("me", "Independent")

# p v.name

# p v

# v = Voter.new("you", "Tea Party")

# p v.name

# p v