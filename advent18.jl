
grid = zeros(Int,(20,20,20))

total = 0
for line in readlines(("advent18.test","advent18.input")[2])
    loc = CartesianIndex((1,1,1) .+ eval(Meta.parse(line)))
    grid[loc] = 1

    total += 6
    if loc[1] > 1 && grid[loc + CartesianIndex(-1,0,0)] == 1
        total -= 2
    end
    if loc[1] < 20 && grid[loc + CartesianIndex(1,0,0)] == 1
        total -= 2
    end
    if loc[2] > 1 && grid[loc + CartesianIndex(0,-1,0)] == 1
        total -= 2
    end
    if loc[2] < 20 && grid[loc + CartesianIndex(0,1,0)] == 1
        total -= 2
    end
    if loc[3] > 1 && grid[loc + CartesianIndex(0,0,-1)] == 1
        total -= 2
    end
    if loc[3] < 20 && grid[loc + CartesianIndex(0,0,1)] == 1
        total -= 2
    end
end

total