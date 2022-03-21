class Dog
  attr_reader :nickname

  def initialize(n)
    @nickname = n
  end

  def change_nickname(n)
    self.nickname = n
  end

  def say_hi
    puts hi
  end

  def greeting
    "#{nickname.capitalize} says Woof Woof!"
  end

  private
    attr_writer :nickname

  def hi
    "hi"
  end
end

dog = Dog.new("rex")
dog.change_nickname("barny")
puts dog.greeting
dog.say_hi
