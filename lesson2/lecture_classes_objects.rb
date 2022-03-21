class Person
  attr_accessor :first_name, :last_name

  def initialize(n)
    parse_full_name(n)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(n)
    parse_full_name(n)
  end

  def to_s
    name
  end

  private

  def parse_full_name(full_name)
    parts = full_name.split
    self.first_name = parts.first
    self.last_name = parts.size > 1 ? parts.last : ''
  end
end

# bob = Person.new("Robert")
# p bob.name
# p bob.first_name
# p bob.last_name
# bob.last_name = 'Smith'
# p bob.name

bob = Person.new('Robert Smith')
puts "The person's name is: #{bob}"
