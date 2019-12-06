---
title: Implement Linked List With Ruby
date: 2019-12-06
tags: ["RUBY"]
---

## Define Node

```ruby
class Node
  attr_accessor :next, :value

  def initialize(value)
    @value = value
    @next  = nil
  end
end
```

## Define Linked List

```ruby
class LinkedList
  attr_accessor :head, :length

  def initialize
    @head = nil
    @length = 0
  end
end
```

## Display Linked List

```ruby
def show_all
  current_node = @head
  puts ":----- Linked List: ----->"

  while(current_node)
    puts "object_id: #{current_node.object_id} - value: #{current_node.value}\n"
    current_node = current_node.next
  end
end
```

## Add New Node

```ruby
def add(value)
  current_node = @head

  if current_node
    while(current_node.next)
      current_node = current_node.next
    end
    current_node.next = Node.new(value)
  else
    @head = Node.new(value)
  end

  @length += 1
end
```

## Delete A Node At Position

```ruby
def delete(position)
  return false if(!@head || position > @length)

  prev_node = current_node = @head
  i = 0

  while(current_node)
    if(i == position)
      prev_node.next = current_node.next
      return true
    end

    prev_node = current_node
    current_node = current_node.next
    i += 1
  end

  return false
end
```

## Reverse Linked List

```ruby
def reverse
  mid = @length / 2
  i = 1
  current_node = @head

  while(i <= mid)
    swap(current_node, find_nth_from_end_list(i))
    current_node = current_node.next
    i += 1
  end
end
```

## Check Circular Linked List

```ruby
def is_circular_linked_list?
  return false if !@head
  hash = {}

  current_node = @head
  while(current_node)
    return false if(hash.key?(current_node.object_id))

    hash[current_node.object_id] = true
    current_node = current_node.next
  end

  return false
end
```

## Full Example

```ruby
class Node
  attr_accessor :next, :value

  def initialize(value)
    @value = value
    @next  = nil
  end
end

class LinkedList
  attr_accessor :head, :length

  def initialize
    @head = nil
    @length = 0
  end

  def show_all
    current_node = @head
    puts ":----- Linked List: ----->"

    while(current_node)
      puts "object_id: #{current_node.object_id} - value: #{current_node.value}\n"
      current_node = current_node.next
    end
  end

  def add(value)
    current_node = @head

    if current_node
      while(current_node.next)
        current_node = current_node.next
      end
      current_node.next = Node.new(value)
    else
      @head = Node.new(value)
    end

    @length += 1
  end

  def delete(position)
    return false if(!@head || position > @length)

    prev_node = current_node = @head
    i = 0

    while(current_node)
      if(i == position)
        prev_node.next = current_node.next
        return true
      end

      prev_node = current_node
      current_node = current_node.next
      i += 1
    end

    return false
  end

  # find node nth from the end of linked list
  def find_nth_from_end_list(n)
    return nil if (n < 0 || n > @length || !@head)

    current_node = @head
    i = 0

    while(current_node)
      if(i + n == @length)
        return current_node
      else
        i += 1
        current_node = current_node.next
      end
    end
  end

  # remove duplicate node
  def remove_duplicate
    current_node = @head
    hash = {}
    i = 0
    sum_of_deleted = 0

    while(current_node)
      if(hash.key?(current_node.value))
        # position in the next duplicate  will change after we remove any items
        delete(i - sum_of_deleted)
        sum_of_deleted += 1
      else
        hash[current_node.value] = true
      end

      i += 1
      current_node = current_node.next
    end
  end

  # remove middle node
  def remove_middle_node
    position = @length/2

    i = 0
    prev_node = current_node = @head

    while(current_node)
      if(i == position)
        prev_node.next = current_node.next
        break
      else
        prev_node = current_node
        current_node = current_node.next
        i += 1
      end
    end
  end

  def reverse
    mid = @length / 2
    i = 1
    current_node = @head

    while(i <= mid)
      swap(current_node, find_nth_from_end_list(i))
      current_node = current_node.next
      i += 1
    end
  end

  # plus two linked list
  def plus(l2)
    result = LinkedList.new
    curr1 = @head
    curr2 = l2.head
    remember_number = 0

    while(curr1 || curr2)
      val1 = curr1 ? curr1.value : 0
      val2 = curr2 ? curr2.value : 0

      sum = val1 + val2 + remember_number

      if sum >= 10
        sum %= 10
        remember_number = 1
      end

      result.add(sum)

      curr1 = curr1.next
      curr2 = curr2.next
    end

    result
  end

  def is_circular_linked_list?
    return false if !@head
    hash = {}

    current_node = @head
    while(current_node)
      return false if(hash.key?(current_node.object_id))

      hash[current_node.object_id] = true
      current_node = current_node.next
    end

    return false
  end

  private

  def swap(node1, node2)
    tmp_value = node2.value
    node2.value = node1.value
    node1.value = tmp_value
  end
end
```

## Source

> [https://github.com/hdchinh/ruby_cracking_code/tree/master/linked_lists](https://github.com/hdchinh/ruby_cracking_code/tree/master/linked_lists)
