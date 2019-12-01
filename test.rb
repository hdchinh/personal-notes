class Node
  attr_accessor :left, :right, :value

  def initialize(val)
    @value = val
  end

  def add(new_val)
    return if @value == new_val
    if(@value > new_val)
      add_left(new_val)
    else
      add_right(new_val)
    end
  end

  def include?(val)
    return true if(@value == val)

    if(@value > val)
      return false if !@left
      @left.include?(val)
    else
      return false if !@right
      @right.include?(val)
    end
  end

  private

  def add_left(val)
    if(@left)
      @left.add(val)
    else
      @left = Node.new(val)
    end
  end

  def add_right(val)
    if(@right)
      @right.add(val)
    else
      @right = Node.new(val)
    end
  end

end

a = Node.new(5)
puts "#{a.value} | #{a.left ? a.left.value : nil} | #{a.right ? a.right.value : nil}"

a.add(2)
a.add(7)
a.add(9)

b = a.right
puts "#{b.value} | #{b.left ? b.left.value : nil} | #{b.right ? b.right.value : nil}"
