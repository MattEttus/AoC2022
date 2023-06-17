
lines = readlines("advent3.input")
lines = readlines("advent3.test")


total = 0
for line in lines
    for letter in line[1:Int(length(line)/2)]
        if letter in line[Int(length(line)/2)+1:end]
            if isuppercase(letter)
                total += Int(letter)-38
            else
                total += Int(letter)-96
            end
            break
        end
    end
end

println(total)

total = 0
for l in 1:Int(length(lines)/3)
    s = intersect(Set(lines[3*l-2]),Set(lines[3*l-1]),Set(lines[3*l]))
    for letter in s
        if isuppercase(letter)
            total += Int(letter)-38
        else
            total += Int(letter)-96
        end
    end
end

println(total)