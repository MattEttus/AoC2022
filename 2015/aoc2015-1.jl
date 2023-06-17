
sum = 0
count = 0
done = false

for line in readlines("input2015-1.txt")
    for char in line
        count += 1
        if char == '('
            sum += 1
        else
            sum -= 1
        end
        if ~done && sum < 0
            done = true
            println("Basement at ", count)
        end
    end
end
println(sum)