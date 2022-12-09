
lines = readlines("advent-1a.input")

most = 0
running_total = 0
counts = []
for line in lines
    try
        running_total += parse(Int,line)
    catch
        most = max(most, running_total)
        push!(counts,running_total)
        running_total = 0
    end   
end
push!(counts,running_total)
println("Max is ", most)
println("Top 3: ", (sort(counts,rev=true)[1:3]))
println("Top 3 sum: ", sum(sort(counts,rev=true)[1:3]))