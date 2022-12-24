
filename = ("advent23.test","advent23.input")[1]
lines = readlines(filename)
grove = fill(false, length(lines), length(lines[1]))

for (r,line) in enumerate(lines)
    for (c,char) in enumerate(line)
        if char == '#'
            grove[r,c] = true
        end
    end
end

north = ([CartesianIndex(mv) for mv in [(-1,-1),(-1,0),(-1,1)]], CartesianIndex(-1,0))
south = ([CartesianIndex(mv) for mv in [(1,-1),(1,0),(1,1)]], CartesianIndex(1,0))
west = ([CartesianIndex(mv) for mv in [(1,-1),(0,-1),(-1,-1)]], CartesianIndex(0,-1))
east = ([CartesianIndex(mv) for mv in [(1,1),(0,1),(-1,1)]], CartesianIndex(0,1))
dirs = [north,south,west,east]
all_adj = [CartesianIndex(mv) for mv in [(1,1),(1,0),(1,-1),(0,1),(0,-1),(-1,1),(-1,0),(-1,1)]]

# phase must start at 0
function move(grove, loc, phase)
    if ~reduce(|,grove[Array.(all_adj).+Array(loc)])
        return nothing
    end
    for (dir,mv) in dirs[(phase.+(0:3)).% 4 .+ 1]
        if         
        end 
end

north?(grove, )