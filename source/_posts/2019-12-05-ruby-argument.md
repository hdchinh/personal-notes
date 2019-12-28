---
title: How To Use Arguments In Ruby
date: 2019-12-05
tags: ["RUBY", "TIL"]
---

## How Many Kind Of Arguments In Ruby?

We can answer: **Three**

1. Required arguments

eg:

```ruby
def hello(name)
  puts "Hello #{name}"
end
```

In there, *name* is a required argument. it mean if you call **hello** method and do not pass an argument, the output that you see should like:

```ruby
hello()

=> ArgumentError: wrong number of arguments (given 0, expected 1)

```

Let pass an argument and this error will gone.

```ruby
hello('Meo Meo')

=> "Hello Meo Meo"
```

It's very simple, I think we are make sence now.

2. Default arguments

Almost like **Required arguments**. It has one more thing different:

That is when we pass argument in a method, we can set default value for it, and then when you call this method and unlucky forgot pass arguments for this method, your method still working, if it's not received arguments when it is called, it will use the default value.

eg:

```ruby
def hello(name = "Meo Meo")
  puts "Hello #{name}"
end

hello("Chinh")
=> "Hello Chinh"

# if you don't pass an argument
hello()
=> "Hello Meo Meo"
```

3. Optional arguments

Do you ever want to create a method and have no idea how many arguments does this method need?

Yes, we use optional arguments for this case, take a looke at the example below:

```ruby
def hello(*family)
  family.each do |name|
    puts "Hello #{name}\n"
  end
end

hello('Chinh', 'Chuot', 'Cho')

# The output:
# Hello Chinh
# Hello Chuot
# Hello Cho
```

## Keyword Arguments

It's a new feature has come from ruby 2.0 to higher. It like pass arguments as a hash but more powerful.

eg:

```ruby
def hello(name: 'Chinh', age: 25)
  puts "Name: #{name} - Age: #{age}\n"
end
```

if you call **hello** method with no arguments:

```ruby
hello()
```

It will use default value.

And then

If you pass argumets for it:

```ruby
hello('Chinh', 25)
```

what will it return?

**Error**: yes, it will response an error, but why?

Because, with **keyword arguments**, you need to pass argumetns like a hash you declare when initial method. (**same key**).

```ruby
hello(name: 'Meo')
# Hello Meo - Age: 25

hello(age: 10)
# Hello Chinh - Age: 10

hello(name: 'Chuot', age: 11)
# Hello Chuot - Age: 11
```

If you want to required an argument with no default value, try this:

```ruby
def hello(name:, age:)
  puts "Name: #{name} - Age: #{age}\n"
end
```

It mean the method need to receive "a hash" with two key *name* and *age*. if it does not revieve, error will raise.
