
nice = 0

vowels = Set("aeiou")
naughty = Set(["ab","cd","pq","xy"])
for line in readlines("input2015-5.txt")
    count = 0
    for ch in line
        if ch in vowels
            count += 1
        end
    end
    if count < 3
        continue
    end

    success = false
    for c in 2:length(line)
        if line[c-1] == line[c]
            success = true
            break
        end
    end

    if ~success 
        continue
    end

    for c in 2:length(line)
        if line[c-1:c] in naughty
            success = false
            break
        end
    end

    if success
        nice += 1
    end
end