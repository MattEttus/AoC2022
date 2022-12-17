
(filename, line_of_interest) = [("advent15.test", 10), ("advent15.input", 2000000)][2]

function parse_line(line)
    delim1 = findfirst(',',line)-1
    delim2 = findfirst(':',line)-1
    xs = parse(Int, line[13:delim1])[1]
    ys = parse(Int, line[delim1+5:delim2])

    delim3 = findall('=',line)[3]+1
    delim4 = findall(',',line)[2]-1
    xb = parse(Int, line[delim3:delim4])
    yb = parse(Int, line[delim4+5:end])

    return (xs,ys,xb,yb)
end

coords = []
for line in readlines(filename)
    push!(coords,parse_line(line))
end

function coords_to_ranges(coords, line_of_interest)
    ranges = []
    for (xs, ys, xb, yb) in coords
        dist = sum(abs.((xs,ys).-(xb,yb)))
        ydist = abs(ys-line_of_interest)
        if dist < ydist
            continue
        end
        yrem = dist-ydist
        push!(ranges,xs-yrem:xs+yrem)
    end
    ranges
end

function consolidate_ranges(ranges)
    sort!(ranges)
    out = []
    s = ranges[1][1]
    e = ranges[1][end]
    for i in 2:length(ranges)
        if ranges[i][1] > e + 1
            push!(out,s:e)
            s = ranges[i][1]
            e = ranges[i][end]
        else
            e = max(e,ranges[i][end])
        end
    end
    push!(out,s:e)
end

ranges = coords_to_ranges(coords, line_of_interest)
cons = consolidate_ranges(ranges)

println("Part 1 answer: $(length(cons[1])-1)")

function find_broken_range(coords, yrange)
    Threads.@threads for y in yrange
        ranges = coords_to_ranges(coords, y)
        cons = consolidate_ranges(ranges)
        if length(cons) > 1
            println("Broken in line $y : $cons")
            println(cons)
            return (y,cons)
        end
    end
end

(y, cons) = find_broken_range(coords,0:4000000)
println("Part 2 Answer = $(y+4000000*(cons[1][end]+1))")