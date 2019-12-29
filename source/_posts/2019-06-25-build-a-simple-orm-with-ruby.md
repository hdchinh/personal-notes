---
title: "Build A Simple ORM"
date: 2019-06-26
draft: false
tags: ["ORM", "RUBY"]
categories: ["RUBY"]
---

## 1. Intro

Does ROR is a great framework? Yes, it does, to me, it's lighting and very powerful. Although, the ROR project needs more RAM than most other frameworks and also difficult to scale up.

But ROR is stale, high security and has very very library supported. And the last one, ROR is the first technology I learn after I graduated from university, therefore I love Rails.

one of the reasons why many people love and use Rails today is ActiveRecord. The default ORM of Rails, more powerful and easy to use. It helps too much for us when we want to build a web app without deep experiences in SQL.

Like many developers, when I start to learn Rails, I used a few methods of ActiveRecord and don't care what's happening after these methods.  Not bad for a beginner, but if I want to become a   good developer, I need to know more details behind these methods, know deep enough to use them better.

## 2. Source Code

> The resource of this post you can see [here](https://github.com/hdchinh/simple-orm-ruby)

## 3. Explaintion

> The first action we need to do after read more is known what is ORM. You can read more about ORM by [article](https://en.wikipedia.org/wiki/Object-relational_mapping).

To build a simple ORM and run a few basic methods, we need to do 2 things:

1. Connect database (I use Postgresql for my example).
2. Create Class using any languages that you familiar with, for me I use Ruby.

**STEP 1: Create project**

Create an empty project with single Gemfile with the content below:

```ruby
source 'https://rubygems.org'

gem 'pg'
```

Install gem by command **bundle install**

If you get errors. let's read more about bundler gem.

**STEP 2: Connect to Database.**

Create a file for the connection. I named this file is **connection.rb**:

```ruby
require 'pg'

$conn = PG::Connection.connect(
  :hostaddr=>"127.0.0.1", :port=>5432,
  :dbname=>"test-psql_development",
  :user=>"admin",
  :password=>''
)
```

Note: The content above is my info login of my Database, You must change for your Database.

At this time, our project has the structure:

```
-- simple-orm
  -- Gemfile
  -- Gemfile.lock (sinh ra sau lệnh `bundle install`)
  -- connection.rb
```

**STEP 3: Create Main Class.**

Create the main class, I named this file is **mybase.rb**. You can name it with any names you like, don't matter:

```ruby
require_relative 'connection.rb'

class MyBase
  def self.all
    term = "SELECT * FROM #{self.name.downcase}"
    res = $conn.exec(term)

    res.each{ |row|
      puts "#{row}\n"
    }
  end

  def self.find(id)
    term = "SELECT * FROM #{self.name.downcase} where id = #{id}"
    res = $conn.exec(term)

    res.each{ |row|
      puts "#{row}\n"
    }
  end
end
```

In this example above, I create two methods:

**all**: To return all records of this Class.
**find**: To find a record by ID.

**STEP 4: Create Child Class Of Main Class.**

In my Database, I have a table called comics. So I create a file named **comics.rb** to handle the comics table:

```ruby
require_relative 'mybase.rb'

class Comics < MyBase; end

puts "All record in comics table:\n"
Comics.all
puts "Find record has id is 6:\n"
Comics.find(6)
```

Finally, my project has the structure below:

```
-- simple-orm
  -- Gemfile
  -- Gemfile.lock (sinh ra sau lệnh `bundle install`)
  -- connection.rb
  -- mybase.rb (main chính chứa các phương thức)
  -- comics.rb (class ứng với table comics trong csdl, kế thừa MyBase)
```

Run **comics.rb** file with command **ruby comics.rb** to see what's happening (please create your sample data first.)

## References

[1][https://en.wikipedia.org/wiki/Object-relational_mapping](https://en.wikipedia.org/wiki/Object-relational_mapping)

[2][https://medium.com/@violetmoon/understanding-orm-frameworks-with-ruby-and-activerecord-83a9e9d8490e](https://medium.com/@violetmoon/understanding-orm-frameworks-with-ruby-and-activerecord-83a9e9d8490e)

[3][https://stackoverflow.com/questions/2194915/what-is-orm-as-related-to-ruby-on-rails](https://stackoverflow.com/questions/2194915/what-is-orm-as-related-to-ruby-on-rails)
