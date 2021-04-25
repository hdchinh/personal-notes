arr = [1, 4, 2, 10, 2, 3, 1, 0, 20]


def sliding_window(arr, k)
  return nil unless arr.size > k

  current_sub_arr = arr[0..(k - 1)]
  run = k

  while run <= arr.size - 1
    tmp = current_sub_arr.sum + arr[run] - current_sub_arr.first

    current_sub_arr = arr[(run - k + 1)..run] if tmp > current_sub_arr.sum

    run += 1
  end

  puts "Max sub arr: #{current_sub_arr.sum}"
end

def sliding_window2(arr, k)
  first_pointer = 0
  second_pointer = k - 1

  max = arr[first_pointer..second_pointer].sum

  arr_length = arr.size

  run = k

  while run < arr_length
    if arr[(first_pointer + 1)..run].sum > max
      first_pointer = run - k + 1
      second_pointer = run
    end

    run += 1
  end

  puts "Max sub arr: #{arr[first_pointer..second_pointer].sum}"
end

sliding_window(arr, 3)
sliding_window2(arr, 3)
