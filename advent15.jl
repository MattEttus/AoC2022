
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

extent = Set()
for (xs, ys, xb, yb) in coords
    dist = sum(abs.((xs,ys).-(xb,yb)))
    ydist = abs(ys-line_of_interest)
    yrem = dist-ydist
    extent = union(extent,xs-yrem:xs+yrem)
end

println(length(extent)-1)   # not sure why have to subtract 1