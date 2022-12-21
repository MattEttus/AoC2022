
@enum Block air rock steam

grid = fill(air,(20,20,20))

total = 0
for line in readlines(("advent18.test","advent18.input")[2])
    loc = CartesianIndex((1,1,1) .+ eval(Meta.parse(line)))
    grid[loc] = rock

    total += 6
    if loc[1] > 1 && grid[loc + CartesianIndex(-1,0,0)] == rock
        total -= 2
    end
    if loc[1] < 20 && grid[loc + CartesianIndex(1,0,0)] == rock
        total -= 2
    end
    if loc[2] > 1 && grid[loc + CartesianIndex(0,-1,0)] == rock
        total -= 2
    end
    if loc[2] < 20 && grid[loc + CartesianIndex(0,1,0)] == rock
        total -= 2
    end
    if loc[3] > 1 && grid[loc + CartesianIndex(0,0,-1)] == rock
        total -= 2
    end
    if loc[3] < 20 && grid[loc + CartesianIndex(0,0,1)] == rock
        total -= 2
    end
end

println("Part 1: $total")

function fill_steam(grid,loc)
    for i in Tuple(loc)
        if i>20 || i<1
            return 0
        end
    end

    if grid[loc] == rock
        return 1
    end
    if grid[loc] == steam
        return 0
    end

    total = 0
    grid[loc] = steam

    for dir in [
        CartesianIndex(-1,0,0),
        CartesianIndex(1,0,0),
        CartesianIndex(0,-1,0),
        CartesianIndex(0,1,0),
        CartesianIndex(0,0,-1),
        CartesianIndex(0,0,1)]
        total += fill_steam(grid,loc + dir)
    end
    return total
end

total = fill_steam(grid,CartesianIndex(1,1,1))

# Account for outside edges
total += sum(grid[1,:,:].==rock) + sum(grid[20,:,:].==rock) + sum(grid[:,1,:].==rock) +
    sum(grid[:,20,:].==rock) + sum(grid[:,:,1].==rock) + sum(grid[:,:,20].==rock)

println("Part 2: $total")