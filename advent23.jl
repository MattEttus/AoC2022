
north = ([CartesianIndex(mv) for mv in [(-1,-1),(-1,0),(-1,1)]], CartesianIndex(-1,0))
south = ([CartesianIndex(mv) for mv in [(1,-1),(1,0),(1,1)]], CartesianIndex(1,0))
west = ([CartesianIndex(mv) for mv in [(1,-1),(0,-1),(-1,-1)]], CartesianIndex(0,-1))
east = ([CartesianIndex(mv) for mv in [(1,1),(0,1),(-1,1)]], CartesianIndex(0,1))
dirs = [north,south,west,east]
all_adj = [CartesianIndex(mv) for mv in [(1,1),(1,0),(1,-1),(0,1),(0,-1),(-1,1),(-1,0),(-1,-1)]]

# phase must start at 0
function propose_move(grove, loc, phase, moves)
    @assert grove[loc] == true
    if ~reduce(|,grove[Ref(loc) .+ all_adj])
        return
    end
    for (dir,mv) in dirs[(phase.+(0:3)).% 4 .+ 1]
        if ~reduce(|,grove[Ref(loc) .+ dir])
            # if (loc + mv) ∉ moves
            if ~haskey(moves,loc+mv)
                moves[loc+mv] = loc
            else
                moves[loc+mv] = nothing
            end
            return
        end
    end
end

function propose_moves(grove, phase)
    moves = Dict{CartesianIndex,Union{Nothing,CartesianIndex}}()
    for loc in findall(grove)
        propose_move(grove, loc, phase, moves)
    end
    return moves
end

function perform_moves(grove, moves)
    for (dest,src) in moves
        if src !== nothing
            grove[src] = false
            grove[dest] = true
        end
    end
end

function enlarge(grove)
    if reduce(|,grove[1,:])
        println("enlarge up")
        newgrove = Array{Bool}(undef,(size(grove).+(1,0))...)
        newgrove[2:end,:] = grove
        newgrove[1,:] .= false
        grove = newgrove
    end
    if reduce(|,grove[end,:])
        println("enlarge down")
        newgrove = Array{Bool}(undef,(size(grove).+(1,0))...)
        newgrove[1:end-1,:] = grove
        newgrove[end,:] .= false
        grove = newgrove
    end    
    if reduce(|,grove[:,1])
        println("enlarge left")
        newgrove = Array{Bool}(undef,(size(grove).+(0,1))...)
        newgrove[:,2:end] = grove
        newgrove[:,1] .= false
        grove = newgrove
    end
    if reduce(|,grove[:,end])
        println("enlarge right")
        newgrove = Array{Bool}(undef,(size(grove).+(0,1))...)
        newgrove[:,1:end-1] = grove
        newgrove[:,end] .= false
        grove = newgrove
    end
    return grove
end

function run_cycle(grove,phase)
    println("Phase: $phase")
    moves = propose_moves(grove,phase)
    if isempty(moves)
        return false
    end
    perform_moves(grove,moves)
    grove = enlarge(grove)
    println(size(grove))
    return grove
end

function print_grove(grove)
    for i in 1:(size(grove)[1])
        for j in 1:(size(grove)[2])
            if grove[i,j]
                print("#")
            else
                print(".")
            end
        end
        println()
    end
end

filename = ("advent23.test","advent23.input")[2]
lines = readlines(filename);
grove = fill(false, length(lines), length(lines[1]));
for (r,line) in enumerate(lines)
    for (c,char) in enumerate(line)
        if char == '#'
            grove[r,c] = true
        end
    end
end
grove = enlarge(grove);

phase = 0
for phase in 0:9
    grove = run_cycle(grove,phase);
    print_grove(grove)
end
ans = reduce(*,(size(grove) .- (2,2))) - sum(grove)
println("Part 1 answer:$ans")

phase = 10
while true
    grove = run_cycle(grove,phase);
    phase += 1
    if grove == false
        break
    end
end
println("Part 2 answer:$phase")
