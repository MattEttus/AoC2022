
moves = Dict(
    [
        ('>',CartesianIndex(0,1)),
        ('<',CartesianIndex(0,-1)),
        ('^',CartesianIndex(-1,0)),
        ('v',CartesianIndex(1,0)),
    ]
)
pos = CartesianIndex(0,0)
locs = Set{CartesianIndex}()

push!(locs,pos)
for line in readlines("input2015-3.txt")
    for ch in line
        pos += moves[ch]
        push!(locs,pos)
    end
end
length(locs)

posns = [CartesianIndex(0,0),CartesianIndex(0,0)]
locs = Set{CartesianIndex}()
count = 0

push!(locs,posns[1])
push!(locs,posns[2])

for line in readlines("input2015-3.txt")
    for ch in line
        posns[count % 2 + 1] += moves[ch]
        push!(locs,posns[count % 2 + 1])
        count += 1
    end
end
length(locs)