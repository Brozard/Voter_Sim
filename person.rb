class Person
  @@num_of_people = 0
  attr_accessor :name
  attr_accessor :person_id

  def initialize(name)
    @name = name
    @person_id = @@num_of_people
    @@num_of_people += 1
  end

  def self.people_count
    @@num_of_people
  end
end