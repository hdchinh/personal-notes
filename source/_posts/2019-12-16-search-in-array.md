---
title: Searching In Array
date: 2019-12-16
tags: ["RUBY"]
---

## Binary Search

```ruby
a = [1, 2, 3, 4, 5, 6, 7, 8, 9]

def binary_search(nums, left, right, target)
  while left <= right
    mid = (left + right) / 2

    return mid if nums[mid] == target

    if target < nums[mid]
      right = mid - 1
      return binary_search(nums, left, right, target)
    else
      left = mid + 1
      return binary_search(nums, left, right, target)
    end
  end

  return -1
end

binary_search(a, 0, 8, 5)

```

> ...
