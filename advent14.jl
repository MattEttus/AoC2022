
@enum Space air sand stone

Base.parse(::Type{CartesianIndex},str) = CartesianIndex( Tuple([parse(Int,coord) for coord in split(str,",")]))

down(coord) = coord + CartesianIndex(0,1)
down_left(coord) = coord + CartesianIndex(-1,1)
down_right(coord) = coord + CartesianIndex(1,1)

grid = fill(air,1000,1000)
max_y = 0

for line in readlines(["advent14.test", "advent14.input"][1])
    lsplit = split(line, "->")
    start = parse(CartesianIndex,lsplit[1])
    for endpt in lsplit[2:end]
        endpt_coord = parse(CartesianIndex,endpt)
        if start <= endpt_coord
            s,e = start, endpt_coord
        else
            s,e = endpt_coord, start
        end
        for coord in s:e
            grid[coord] = stone
            if coord[2] > max_y
                max_y = coord[2]
            end
        end
        start = endpt_coord
    end
end

grain_count = 0
while true
    grain_count += 1
    cur_space = CartesianIndex(500,0)
    while cur_space[2] <= max_y
        if grid[down(cur_space)] == air
            cur_space = down(cur_space)
        elseif grid[down_left(cur_space)] == air
            cur_space = down_left(cur_space)    
        elseif grid[down_right(cur_space)] == air
            cur_space = down_right(cur_space)
        else
            grid[cur_space] = sand
            break
        end
    end
    println("Grain $grain_count --> Came to rest at $cur_space")
    if cur_space[2] > max_y
        println("Done: $grain_count")
        break
    end
end
println("Part 1 answer: $(grain_count-1)")