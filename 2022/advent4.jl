
lines = readlines("advent4.input")
lines = readlines("advent4.test")

total = 0
for line in lines
    x = split.(split(line,','),'-')
    if parse(Int,x[1][1]) <= parse(Int,x[2][1]) && parse(Int,x[1][2]) >= parse(Int,x[2][2])
        total += 1
    elseif parse(Int,x[1][1]) >= parse(Int,x[2][1]) && parse(Int,x[1][2]) <= parse(Int,x[2][2])
        total += 1
    end
end

println(total)

total = 0
for line in lines
    x = split.(String.(split(line,',')),'-')
    if parse(Int,x[1][1]) == parse(Int,x[2][1])
        total += 1
        continue
    elseif parse(Int,x[1][1]) < parse(Int,x[2][1])
        if parse(Int,x[1][2]) >= parse(Int,x[2][1])
            total += 1
            continue
        end
    elseif parse(Int,x[1][1]) <= parse(Int,x[2][2])
        total += 1
        continue
    end
end


println(total)
