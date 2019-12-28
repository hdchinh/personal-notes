---
title: Example Of Two Pointer With Ruby
date: 2019-12-20
tags: ["RUBY"]
---

## [3sum-closest](https://leetcode.com/problems/3sum-closest/submissions/)

![bai giai](/../images/3sum_2.jpeg)

```ruby
def three_sum_closest(nums, target)
  nums.sort!

  length = nums.size
  kq = nums[0] + nums[1] + nums[length - 1]

  0.upto(length - 2) do |i|
    ptr1 = i + 1
    ptr2 = length - 1

    while ptr1 < ptr2
      sum = nums[i] + nums[ptr1] + nums[ptr2]

      return target if (target - sum).abs == 0

      kq = sum if (target - sum).abs < (target - kq).abs

      if sum > target
        ptr2 -= 1
      else
        ptr1 += 1
      end
    end

  end

  kq
end
```


## [container-with-most-water](https://leetcode.com/problems/container-with-most-water/submissions/)

![bai giai](/../images/question_11.jpg)

```ruby
def get_container_water(arr, a, b)
  h = arr[a] >= arr[b] ? arr[b] : arr[a]
  h * (b - a).abs
end

def max_area(height)
  start = 0
  finish = height.size - 1

  max = get_container_water(height, start, finish)

  while start < finish
    if height[start] >= height[finish]
      finish -= 1
      return max if finish <= start
    else
      start += 1
      return max if start >= finish
    end

    max = get_container_water(height, start, finish) if get_container_water(height, start, finish) > max
  end

  max
end
```
