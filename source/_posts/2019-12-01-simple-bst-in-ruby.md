---
title: Simple BST With Ruby
date: 2019-12-01
tags: ["RUBY"]
---

![vang con](/../images/vangcon.jpeg)

## Init

```ruby
class Node
  attr_accessor :left, :right, :value

  def initialize(val)
    @value = val
  end
end
```

## Display Tree

```ruby
def get_tree
  puts "#{value}\n"
  @left.get_tree() if @left
  @right.get_tree() if @right
end
```

## Add Node

```ruby
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
```

## Check existing?

```ruby
class Node
  attr_accessor :left, :right, :value

  def initialize(val)
    @value = val
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
end
```

## Update Node

```ruby
def update(current_value, new_value)
  if(@value == current_value)
    @value = new_value
    return true
  end

  if(@value > current_value)
    return false if !@left
    @left.update(current_value, new_value)
  else
    return false if !@right
    @right.update(current_value, new_value)
  end
end
```

## Example

```ruby
class Node
  attr_accessor :left, :right, :value

  def initialize(val)
    @value = val
  end

  def get_tree
    puts "#{value}\n"
    @left.get_tree() if @left
    @right.get_tree() if @right
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

  def update(current_value, new_value)
    if(@value == current_value)
      @value = new_value
      return true
    end

    if(@value > current_value)
      return false if !@left
      @left.update(current_value, new_value)
    else
      return false if !@right
      @right.update(current_value, new_value)
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

a.get_tree()

a.update(7, 6)

puts "#{a.value} | #{a.left ? a.left.value : nil} | #{a.right ? a.right.value : nil}"

a.get_tree()

b = a.right
puts "#{b.value} | #{b.left ? b.left.value : nil} | #{b.right ? b.right.value : nil}"

```

-----
