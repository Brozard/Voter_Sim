require "./person.rb"
require "./voter.rb"
require "./politician.rb"

class World
  # attr_accessor :population

  def initialize
    @population = []
    @vote_results = []
  end

  def default_people
    default_politicians = [
      {name: "Bob Dole", party: "Republican"},
      {name: "Bill Clinton", party: "Democrat"},
      {name: "Richard Nixon", party: "Republican"},
      {name: "Barack Obama", party: "Democrat"},
      {name: "George W. Bush", party: "Republican"}
    ]
    default_voters = [
      {name: "Charlie Brown", politics: "Independent"},
      {name: "Lucille van Pelt", politics: "Tea Party"},
      {name: "Charlie Chaplin", politics: "Conservative"},
      {name: "Mickey Mouse", politics: "Conservative"},
      {name: "Booker Catch", politics: "Liberal"},
      {name: "Rickin Morty", politics: "Socialist"},
      {name: "Homer Simpson", politics: "Socialist"},
      {name: "Peter Griffin", politics: "Conservative"},
      {name: "Steve Carell", politics: "Independent"},
      {name: "Adam Warlock", politics: "Tea Party"},
      {name: "Guy Incognito", politics: "Independent"},
      {name: "Adam West", politics: "Conservative"},
      {name: "Matt Murdock", politics: "Liberal"},
      {name: "Jim Holden", politics: "Socialist"},
      {name: "Adolf Hitler", politics: "Socialist"}
    ]
    default_politicians.each do |pol|
      @population << Politician.new(pol[:name], pol[:party])
    end
    default_voters.each do |vote|
      @population << Voter.new(vote[:name], vote[:politics])
    end
  end

  def main_menu
    puts "\nWhat would you like to do?"
    puts "(C)reate, (L)ist, (U)pdate, (D)elete, (V)ote, or (E)xit"
    top_menu_choice = gets.chomp.downcase.capitalize
    case top_menu_choice
    when "C", "Create"
      create
    when "L", "List"
      list
    when "U", "Update"
      update
    when "D", "Delete"
      delete
    when "V", "Vote"
      cast_vote
    when "E", "Exit"
      return
    else
      puts "#{top_menu_choice} is not a valid selection."
      main_menu
    end
    main_menu
  end

  def create
    puts "What would you like to create?"
    puts "Choose from (P)olitician or (V)oter"
    create_choice = gets.chomp.downcase.capitalize
    case create_choice
    when "P", "Politician"
      create_politician
    when "V", "Voter"
      create_voter
    else
      puts "#{create_choice} is not a valid selection."
      create
    end
  end

  def create_politician
    politician_name = assign_name("politician")
    politician_party = assign_party(politician_name)
    @population << Politician.new(politician_name, politician_party)
    puts "#{politician_name} has been added as a #{politician_party} politician."
  end

  def create_voter
    voter_name = assign_name("voter")
    voter_politics = assign_politics(voter_name)
    @population << Voter.new(voter_name, voter_politics)
    article = voter_politics.start_with?("i", "I") ? "an" : "a"
    puts "#{voter_name} has been added as #{article} #{voter_politics} voter."
  end

  def already_exists(name, type)
    puts "#{name} already exists as a #{type}."
  end

  def assign_name(type)
    puts "What is this #{type}'s name?"
    name = set_name
    name_enum_test = name_check(name)
    if name_enum_test != nil
      already_exists(name, @population[name_enum_test].class.to_s.downcase)
      assign_name(type)
    else
      name
    end
  end

  def assign_party(name)
    puts "What is #{name}'s party affiliation?"
    set_party
  end

  def assign_politics(name)
    puts "What is #{name}'s political affiliation?"
    puts "(L)iberal, (C)onservative, (T)ea Party, (S)ocialist, or (I)ndependent"
    politics = gets.chomp.downcase.capitalize
    case politics
    when "L", "Liberal"
      return "Liberal"
    when "C", "Conservative"
      return "Conservative"
    when "T", "Tea Party"
      return "Tea Party"
    when "S", "Socialist"
      return "Socialist"
    when "I", "Independent"
      return "Independent"
    else
      puts "#{politics} is not a valid choice."
      assign_politics(name)
    end
  end

  def list
    puts "*" * 15
    puts "* POLITICIANS *"
    puts "*" * 15
    @population.sort_by{ |pop| pop.name }.each do |p|
      if p.class == Politician
        print "   > #{p.name}, #{p.party}\n"
      end
    end
    
    puts ""
    puts "*" * 15
    puts "*   VOTERS    *"
    puts "*" * 15
    @population.sort_by{ |pop| pop.name }.each do |v|
      if v.class == Voter
        print "   > #{v.name}, #{v.politics}\n"
      end
    end
    puts ""
  end

  def set_name
    typed_name = gets.chomp
    case typed_name
    when ""
      puts "You need to enter a valid name."
      set_name
    else
      typed_name
    end
  end

  def set_party
    puts "Choose from (D)emocrat or (R)epublican"
    party = gets.chomp.downcase.capitalize
    case party
    when "D", "Democrat"
      return "Democrat"
    when "R", "Republican"
      return "Republican"
    else
      puts "#{party} is not a valid choice."
      set_party
    end
  end

  def set_politics
    puts "Choose from (L)iberal, (C)onservative, (T)ea Party, (S)ocialist, or (I)ndependent"
    politics = gets.chomp.downcase.capitalize
    case politics
    when "L", "Liberal"
      return "Liberal"
    when "C", "Conservative"
      return "Conservative"
    when "T", "Tea Party"
      return "Tea Party"
    when "S", "Socialist"
      return "Socialist"
    when "I", "Independent"
      return "Independent"
    else
      puts "#{politics} is not a valid choice."
      set_politics
    end
  end

  def update
    puts "Who would you like to update?"
    name = set_name
    enum = name_check(name)
    if enum == nil
      puts "That person does not exist."
      update
    else
      update_record(enum)
    end
  end

  def update_record(enum)
    new_name = update_name(enum)
    @population[enum].name = new_name
    update_affiliation(enum)
  end

  def update_name(enum)
    puts "What is #{@population[enum].name}'s new name?"
    new_name = set_name
    check_enum = name_check(new_name)
    if (check_enum == nil) || (check_enum == enum)
      new_name
    else
      puts "#{new_name} already exists as a #{@population[check_enum].class.to_s.downcase}."
      update_name(enum)
    end
  end

  def update_affiliation(enum)
    if get_class(enum) == Voter
      @population[enum].politics = update_politics(@population[enum].name)
    elsif get_class(enum) == Politician
      @population[enum].party = update_party(@population[enum].name)
    else
      puts "If you got this message, there's a problem."
    end
  end

  def get_class(enum)
    @population[enum].class
  end

  def update_party(name)
    puts "What is #{name}'s new party?"
    set_party
  end

  def update_politics(name)
    puts "What is #{name}'s new political alignment?"
    set_politics
  end

  def name_check(passed_name)
    @population.index{ |pop| pop.name == passed_name }
  end

  def delete
    puts "Who would you like to delete?"
    name = set_name
    enum = name_check(name)
    if enum == nil
      puts "That person does not exist."
      update
    else
      delete_record(enum)
    end
  end

  def delete_record(enum)
    puts "Are you sure you want to delete this record?"
    print "   > #{@population[enum].name}, "
    if get_class(enum) == Voter
      print "#{@population[enum].politics}\n"
    elsif get_class(enum) == Politician
      print "#{@population[enum].party}\n"
    else
      puts "If you got this message, there's a problem."
    end
    puts "Enter (Y)es or (N)o."
    confirmation = gets.chomp.downcase.capitalize
    case confirmation
    when "Y", "Yes"
      @population.delete_at(enum)
    when "N", "No"
      puts "N"
    else
      puts "Oops"
    end
  end

  def cast_vote
    @vote_results = []
    politicians = init_politicians
    rep_politicians = init_rep_pol
    dem_politicians = init_dem_pol
    voters = init_voters

    voters.each do |v|
      case v.politics
      when "Conservative", "Tea Party"
        @vote_results << rep_politicians.shuffle.first
      when "Liberal", "Socialist"
        @vote_results << dem_politicians.shuffle.first
      when "Independent"
        @vote_results << politicians.shuffle.first
      end
    end

    @vote_results.uniq.each do |pol|
      puts "#{pol.name}, #{pol.party} = #{@vote_results.count { |v| v.name == pol.name}}"
    end
  end

  def init_politicians
    politicians = @population.map do |pop|
      if pop.class == Politician
        pop
      end
    end
    politicians.reject! { |pol| pol == nil }
  end

  def init_rep_pol
    rep_politicians = @population.map do |pop|
      if (pop.class == Politician) && (pop.party == "Republican")
        pop
      end
    end
    rep_politicians.reject! { |pol| pol == nil }
  end

  def init_dem_pol
    dem_politicians = @population.map do |pop|
      if (pop.class == Politician) && (pop.party == "Democrat")
        pop
      end
    end
    dem_politicians.reject! { |pol| pol == nil }
  end

  def init_voters
    voters = @population.map do |pop|
      if pop.class == Voter
        pop
      end
    end
    voters.reject! { |voter| voter == nil }
  end

end

w = World.new

w.default_people

w.main_menu