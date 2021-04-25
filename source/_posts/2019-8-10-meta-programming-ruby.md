---
title: "Metaprograming Ruby 2"
date: 2019-09-21
draft: false
tags: ["NOTES"]
label: "#book"
---

## IMAGES

![hoa](/images/meta2/1.png)

![hoa](/images/meta2/2.png)

![hoa](/images/meta2/3.png)

![hoa](/images/meta2/4.png)

![hoa](/images/meta2/5.png)

<!-- ![hoa](/images/meta2/6.png) -->

![hoa](/images/meta2/7.png)

![hoa](/images/meta2/8.png)

![hoa](/images/meta2/9.png)



## RUBY OBJECT MODEL

### Open Classes


**rails g model Movie title:string director:string**

```ruby
class Movie < ActiveRecord:Base; end
```

1) What about methods such as **title=** and title, which access object attributes (accessor methods for short)? This is where metaprogramming comes in: Bob doesn’t have to write those methods. Active Record defines them automatically, after inferring their names from the database schema. ActiveRecord::Base reads the schema at runtime, discovers that the movies table has two columns named title and director, and defines accessor methods for two attributes of the same name. This means that Active Record defines methods such as **Movie#title** and **Movie#director=** out of thin air while the program runs.

Open Class
```ruby
class Numeric
  def to_money(currency = nil)
    Money.from_numeric(self, currency || Money.default_currency)
  end
end
```

2) As cool as they are, however, Open Classes have a dark side—one that you’re about to experience.

| This can override the method of superclass and make wrong result in somewhere (monkeypath). So we need be careful when set the name for the override method.

### Inside the Object Model

3) Objects that share the same class also share the same methods, so the methods must be stored in the class, not the object.

4) The "false" argument here means: ignore inherited methods Class.instance_methods(false) # => [:allocate, :new, :superclass]

5) The superclass of Class is Module—which is to say, every class is also a module.
To be precise, a class is a module with three additional instance methods (new, allocate, and superclass)

6) All the constants in a program are arranged in a tree similar to a file system.

7) The Module class also provides an instance method and a class method that, confusingly, are both called constants.

8) What’s an object? It’s a bunch of instance variables, plus a link to a class. The object’s methods don’t live in the object—they live in the object’s class, where they’re called the instance methods of the class.

9) What’s a class? It’s an object (an instance of Class), plus a list of instance methods and a link to a superclass. Class is a subclass of Module, so a class is also a module

10) These are instance methods of the Class class. Like any object, a class has its own methods, such as new. Also like any object, classes must be accessed through references. You already have a constant reference to each class: the class’s name.

11) Using load, however, has a side effect. The motd.rb file probably defines variables and classes. Although variables fall out of scope when the file has finished loading, constants don’t. As a result, motd.rb can pollute your program with the names of its own constants—in particular, class names. You can force motd.rb to keep its constants to itself by passing a second, optional argument to load: **load('motd.rb', true)** If you load a file this way, Ruby creates **an anonymous module**, uses that module as a Namespace to contain all the constants from motd.rb, and then destroys the module. The require method is quite similar to load, but it’s meant for a different purpose. You use load to execute code, and you use require to import libraries. That’s why require has no second argument: those leftover class names are probably the reason why you imported the file in the first place. Also, that’s why require tries only once to load each file, while load executes the file again every time you call it.

What’s the class of Object?
What’s the superclass of Module?
What’s the class of Class?

### What Happens When You Call a Method?

12) When you call a method, Ruby does two things:
1. It finds the method. This is a process called method lookup.
2. It executes the method. To do that, Ruby needs something called self.

13) Before you look at a more complicated example, though, you need to know about two new concepts: the receiver and the ancestors chain.The receiver is the object that you call a method on. For example, if you write **my_string.reverse()**, then **my_string** is the receiver. To understand the concept of an ancestors chain, look at any Ruby class. Then imagine moving from the class into its superclass, then into the superclass’s superclass, and so on, until you reach BasicObject, the root of the Ruby class hierarchy. The path of classes you just traversed is the ancestors chain of the class.
MySubclass.ancestors # => [MySubclass, MyClass, Object, Kernel, BasicObject]

14) When you include a module in a class (or even in another module), Ruby inserts the module in the ancestors chain, right above the including class itself:

15) Starting from Ruby 2.0, you also have a second way to insert a module in a class’s chain of ancestors: **the prepend method**. It works like include, but it inserts the module below the including class (sometimes called the includer).

```ruby
class C2
 prepend M2
end
class D2 < C2; end
D2.ancestors # => [D2, M2, C2, Object, Kernel, BasicObject]
```

16) This is true every time you include or prepend a module: if that module is already in the chain, Ruby silently ignores the second inclusion.

Kernel.private_instance_methods.grep(/^pr/) # => [:printf, :print, :proc]

17) The trick here is that class Object includes Kernel, so Kernel gets into every object’s ancestors chain. Every line of Ruby is always executed inside an object, so you can call the instance methods in Kernel from anywhere.

18) You can take advantage of this mechanism yourself: if you add a method to Spell: Kernel Method Kernel, this Kernel Method will be available to all objects. To prove that Kernel Methods are actually useful, you can look at the way some Ruby libraries use them.

19) Every line of Ruby code is executed inside an object—the so-called current object. The current object is also known as self, because you can access it with the self keyword.

20) Only one object can take the role of self at a given time, but no object holds that role for a long time. In particular, when you call a method, the receiver becomes self. From that moment on, all instance variables are instance variables of self, and all methods called without an explicit receiver are called on self.

21) As soon as you start a Ruby program, you’re sitting within an object named main that the Ruby interpreter created for you. This object is sometimes called the top-level context, because it’s the object you’re in when you’re at the top level of the call stack: either you haven’t called any method yet or all the methods that you called have returned.

22) This code refines the String class with a new to_alphanumeric method. Differently from a regular Open Class, however, a Refinement is not active by default. If you try to call   **String#to_alphanumeric**, you’ll get an error: **"my *1st* refinement!".to_alphanumeric ❮ NoMethodError: undefined method 'to_alphanumeric' [...]** To activate the changes, you have to do so explicitly, with the using method: using StringExtensions

23) you can call refine in a regular module, but you cannot call it in a class, even if a class is itself a module.

## METHODS

### Dynamic Methods

24) If that kind of breaching of encapsulation makes you uneasy, you can use public_send instead. It’s like send, but it makes a point of respecting the receiver’s privacy. Be prepared, however, for the fact that Ruby code in the wild rarely bothers with this concern. If anything, a lot of Ruby programmers use send exactly because it allows calling private methods, not in spite of that

```ruby
class DS
  def initialize # connect to data source...
  def get_cpu_info(workstation_id) # ...
  def get_cpu_price(workstation_id) # ...
  def get_mouse_info(workstation_id) # ...
  def get_mouse_price(workstation_id) # ...
  def get_keyboard_info(workstation_id) # ...
  def get_keyboard_price(workstation_id) # ...
  def get_display_info(workstation_id) # ...
  def get_display_price(workstation_id) # ...
  # ...and so on
end
```

```ruby
class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
  end
  
  def mouse
    info = @data_source.get_mouse_info(@id)
    price = @data_source.get_mouse_price(@id)
    result = "Mouse: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    result
  end
   
  def cpu
    info = @data_source.get_cpu_info(@id)
    price = @data_source.get_cpu_price(@id)
    result = "Cpu: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    result
  end
    
  def keyboard
    info = @data_source.get_keyboard_info(@id)
    price = @data_source.get_keyboard_price(@id)
    result = "Keyboard: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    result
  end
   # ...
end
```

DYNAMIC DISPATCH

```ruby
class Computer
  def initialize(computer_id, data_source)
  @id = computer_id
  @data_source = data_source
  end
  
  def mouse
    component :mouse
  end

  def cpu
    component :cpu
  end
    
  def keyboard
    component :keyboard
  end
    
  def component(name)
    info = @data_source.send "get_#{name}_info", @id
    price = @data_source.send "get_#{name}_price", @id
    result = "#{name.capitalize}: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    result
  end
end
```

DYNAMIC METHOD

```ruby
class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
  end
  
  def self.define_component(name)
    define_method(name) do
      info = @data_source.send "get_#{name}_info", @id
      price = @data_source.send "get_#{name}_price", @id
      result = "#{name.capitalize}: #{info} ($#{price})"
      return "* #{result}" if price >= 100
      result
    end
  end
     
  define_component :mouse
  define_component :cpu
  define_component :keyboard
end

```

BEST WAY

```ruby
class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
    data_source.methods.grep(/^get_(.*)_info$/) { Computer.define_component $1 }
  end
    
  def self.define_component(name)
    define_method(name) do
      # ...
    end
  end
end
```

### method_missing

25) The Hashie gem contains a little bit of magic called Hashie::Mash. A Mash is a more powerful version of Ruby’s standard OpenStruct class: a hash-like object whose attributes work like Ruby variables. If you want a new attribute, just assign a value to the attribute, and it will spring into existence:

```ruby
require 'hashie'
icecream = Hashie::Mash.new
icecream.flavor = "strawberry"
icecream.flavor # => "strawberry"
```

What hanppen inside?

```ruby
module Hashie
  class Mash < Hashie::Hash
    def method_missing(method_name, *args, &blk)
      return self.[](method_name, &blk) if key?(method_name)
      match = method_name.to_s.match(/(.*?)([?=!]?)$/)
      case match[2]
      when "="
      self[match[1]] = args.first
      # ...
      else
      default(method_name, *args, &blk)
      end
    end
    # ...
  end
end
```

26) **Ghost Methods** (57) are usually icing on the cake, but some objects actually rely almost exclusively on them. These objects are often wrappers for something else—maybe another object, a web service, or code written in a different language. They collect method calls through method_missing and forward them to the wrapped object. Let’s look at a complex real-life example.

Refactor:

```ruby
class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
  end
  
  def method_missing(name)
    super if !@data_source.respond_to?("get_#{name}_info")
    info = @data_source.send("get_#{name}_info", @id)
    price = @data_source.send("get_#{name}_price", @id)
    result = "#{name.capitalize}: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    result
  end
end
```

27) Khi dùng ghost method, giả sử trong method_missing chúng ta muốn tạo ra 1 method x, tuy nhiên x lại có trong cây kế thừa => x trong method missing sẽ không được gọi. Lúc này ta cần Blank Slates.

### Blank Slates

28) If you don’t need the inherited method, you can fix the problem by removing it. While you’re at it, you might want to remove most methods from the class, preventing such name clashes from ever happening again. A skinny class Spell: Blank Slate with a minimal number of methods is called a Blank Slate. As it turns out, Ruby has a ready-made Blank Slate for you to use

29) If you don’t specify a superclass, your classes inherit by default from Object, which is itself a subclass of BasicObject. If you want a Blank Slate (66), you can inherit directly from BasicObject instead. For example, if Computer inherited directly from BasicObject, then it wouldn’t have a problematic display method.
=> không lấy nhầm method trong class Object, vì lớp Computer được kế thừa trực tiếp từ BasicObject

30) Inheriting from BasicObject is the quicker way to define a Blank Slate in Ruby.
**class Computer < BasicObject**

31) You can remove a method from a class by using either Module#undef_method or Module#remove_method. The drastic undef_method removes any method, including the inherited ones. The kinder remove_method removes the method from the receiver, but it leaves inherited methods alone. Let’s look at a real-life library that uses undef_method to create a Blank Slate.

```ruby
class BlankSlate
  # Hide the method named +name+ in the BlankSlate class. Don't
  # hide +instance_eval+ or any method beginning with "__".
  def self.hide(name)
    # ...
    if instance_methods.include?(name._blankslate_as_name) &&
      name !~ /^(__|instance_eval$)/
      undef_method name
    end
  end
  # ...
  instance_methods.each { |m| hide(m) }
end
```

32) **use Dynamic Methods if you can and Ghost Methods if you have to**


## BLOCKS

### Blocks Are Closures

```ruby
def my_method
  x = "Goodbye"
  yield("cruel")
end

x = "Hello"
my_method {|y| "#{x}, #{y} world" } # => "Hello, cruel world"
```

33) When you create the block, you capture the local bindings, such as x. Then you pass the block to a method that has its own separate set of bindings. In the previous example, those bindings also include a variable named x. Still, the code in the block sees the x that was around when the block was defined, not the method’s x, which is not visible at all in the block.

34) khi gọi 1 block, nó lưu vết lại các ràng buộc cục bộ nơi block được gọi, sau đó block được truyền cho 1 method, mà method đó sẽ có các ràng cuộc cục bộ của riêng nó, và block sẽ sử dụng ràng buộc của mình (ví dụ như biến x ở trên).

```ruby
def just_yield
  yield
end

top_level_variable = 1
just_yield do
  top_level_variable += 1
  local_to_block = 1
end

top_level_variable # => 2
local_to_block # => Error!
```
Trong ví dụ này thì local_to_block là 1 binding thuộc block, và ra ngoài ngữ cảnh block nó không có giá trị.

35) This example shows how scope changes as your program runs, tracking the names of bindings with the Kernel#local_variables method:

```ruby
v1 = 1

class MyClass
  v2 = 2
  local_variables # => [:v2]
  def my_method
    v3 = 3
    local_variables
  end
  local_variables # => [:v2]
end
  
obj = MyClass.new
obj.my_method # => [:v3]
obj.my_method # => [:v3]
local_variables # => [:v1, :obj]
```

36) There are exactly three places where a program leaves the previous scope behind and opens a new one:
Class definitions
Module definitions
Methods

37) Scope changes whenever the program enters (or exits) a class or module definition or a method. These three borders are marked by the keywords class, module, and def, respectively. Each of these keywords acts like a **Scope Gate**.

```ruby
v1 = 1
class MyClass # SCOPE GATE: entering class
  v2 = 2
  local_variables # => ["v2"]
  def my_method # SCOPE GATE: entering def
    v3 = 3
    local_variables
  end # SCOPE GATE: leaving def
  
  local_variables # => ["v2"]
end # SCOPE GATE: leaving class
  
obj = MyClass.new
obj.my_method # => [:v3]
local_variables # => [:v1, :obj]
```

```ruby
my_var = "Success"
  
MyClass = Class.new do
  "#{my_var} in the class definition"
  
  define_method :my_method do
    "#{my_var} in the method"
  end
end
```

khai báo thông thường thì my_var không thể sử dụng trong class hoặc def (vì nó mở ra  1 scope mới). Nên dùng call method gọi là **flat scope**.

38) If you replace Scope Gates with method calls, you allow one scope to see variables from another scope. Technically, this trick should be called nested lexical scopes, but many Ruby coders refer to it simply as “flattening the scope,” meaning that the two scopes share variables as if the scopes were squeezed together. For short, you can call this spell a Flat Scope.

39) Once you know about Flat Scopes (83), you can do pretty much whatever you want with scopes. For example, assume that you want to share a variable among a few methods, and you don’t want anybody else to see that variable. You can do that by defining all the methods in the same Flat Scope as the variable:

```ruby
def define_methods
  shared = 0
  Kernel.send :define_method, :counter do
    shared
  end

  Kernel.send :define_method, :inc do |x|
    shared += x
  end
end

Muốn chỉ share variable cho 1 vài method nhất định, dùng các phương thức support bởi kernel và gọi đây là **Flat Scope**.

```

### instance_eval()

```ruby
v = 2
obj.instance_eval { @v = v }
obj.instance_eval { @v } # => 2
```

40) The three lines in the previous example are evaluated in the same Flat Scope (83), so they can all access the local variable v—but the blocks are evaluated with the object as self, so they can also access obj’s instance variable @v. In all these cases, you can call the block that you pass to instance_eval a Context Probe, because it’s like a snippet of code that you dip inside an object to do Spell: Context Probe something in there

41) To solve this problem Ruby provides the standard library class Proc. 
A Proc isa block that has been turned into an object. You can create a Proc by passing
the block to Proc.new

### Callable Objects

42) To attach a binding to the block, you can add one special argument to the method. This argument must be the last in the list of arguments and prefixed by an & sign.

```ruby
def my_method(&the_proc)
  the_proc
end
    
p = my_method {|name| "Hello, #{name}!" }
p.class # => Proc
p.call("Bill") # => "Hello, Bill!"


def my_method(greeting)
  "#{greeting}, #{yield}!"
end
    
my_proc = proc { "Bill" }
my_method("Hello", &my_proc)
```
When you call my_method, the & converts my_proc to a block and passes that block to the method.

43) There are two differences between procs and lambdas. One has to do with the return keyword, and the other concerns the checking of arguments.

In a lambda, return just returns from the lambda.
In a proc, return behaves differently. Rather than return from the proc, it returns from the scope where the proc itself was defined:

lambdas tend to be less tolerant than procs (and regular blocks) when it comes to arguments. Call a lambda with the wrong arity, and it fails with an ArgumentError. On the other hand, a proc fits the argument list to its own expectations:

```ruby
class MyClass
  def initialize(value)
    @x = value
  end
    
  def my_method
    @x
  end
end
    
object = MyClass.new(1)
m = object.method :my_method
m.call # => 1
```

44) By calling Kernel#method, you get the method itself as a Method object, which you can later execute with Method#call.

### Writing a Domain-Specific Language

N/A

## CLASS DEFINITIONS

### Class Definitions Demystified

### Singleton Methods

### Singleton Classes

### Method Wrappers

45) At the top level of your program, the current class is Object, the class of main. (**That’s why, if you define a method at the top level, that method becomes an instance method of Object.**)

46) Module#class_eval is very different from BasicObject#instance_eval, which you learned about earlier in instance_eval(), on page 85. instance_eval only changes self, **while class_eval changes both self and the current class.**

```ruby
def add_method_to(a_class)
  a_class.class_eval do
    def m; 'Hello!'; end
  end
end

add_method_to String
"abc".m # => "Hello!"
```
