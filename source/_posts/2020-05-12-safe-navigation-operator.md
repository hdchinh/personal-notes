---
title: "Save Navigation Operator"
date: 2020-05-12
tags: ["NOTES"]
label: "#til"
---

> Just take a note from resources on internet!

## 1. ActiveRecord

```ruby
account = Account.new(owner: nil) # account without an owner

account.owner.address
# => NoMethodError: undefined method `address' for nil:NilClass

account && account.owner && account.owner.address
# => nil

account.try(:owner).try(:address)
# => nil

account&.owner&.address
# => nil
```

```ruby
account = Account.new(owner: false)

account.owner.address
# => NoMethodError: undefined method `address' for false:FalseClass `

account && account.owner && account.owner.address
# => false

account.try(:owner).try(:address)
# => nil

account&.owner&.address
# => undefined method `address' for false:FalseClass`
```

```ruby
account = Account.new(owner: Object.new)
# owner have not addreess column

account.owner.address
# => NoMethodError: undefined method `address' for #<Object:0x00559996b5bde8>

account && account.owner && account.owner.address
# => NoMethodError: undefined method `address' for #<Object:0x00559996b5bde8>`

account.try(:owner).try(:address)
# => nil

account&.owner&.address
# => NoMethodError: undefined method `address' for #<Object:0x00559996b5bde8>`
```

Catch exception with `try!`

```ruby
account.try!(:owner).try!(:address)
# => NoMethodError: undefined method `address' for #<Object:0x00559996b5bde8>`
```

## 2. Hash

```ruby
h = {
  key_1: {
    key_2: {
      key_3: "Value"
    }
  }
}
```

```ruby
h&.[](:key_1)&.[](:key_2)&.[](:key_3)
```

```ruby
h.dig(:key_1, :key_2, :key_3)
```

## Resources

[1][http://mitrev.net/ruby/2015/11/13/the-operator-in-ruby/](http://mitrev.net/ruby/2015/11/13/the-operator-in-ruby/)

[2][https://stackoverflow.com/questions/35922774/safe-navigation-equivalent-to-rails-try-for-hashes](https://stackoverflow.com/questions/35922774/safe-navigation-equivalent-to-rails-try-for-hashes)
