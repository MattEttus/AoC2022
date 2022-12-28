# advent19.jl

# Recipes
struct Recipe
    rec::Vector{Int}
end

Recipe() = Recipe(zeros(Int,8))

function Recipe(strs)
    if strs[2] == "ore"
        Recipe([-parse(Int,strs[5]),0,0,0,1,0,0,0])
    elseif strs[2] == "clay"
        Recipe([-parse(Int,strs[5]),0,0,0,0,1,0,0])
    elseif strs[2] == "obsidian"
        Recipe([-parse(Int,strs[5]),-parse(Int,strs[8]),0,0,0,0,1,0])
    elseif strs[2] == "geode"
        Recipe([-parse(Int,strs[5]),0,-parse(Int,strs[8]),0,0,0,0,1])
    else
        throw("Bad Input")
    end
end

function load_blueprints(filename)
    bps = []
    for bp in readlines(filename)
        fields = split(bp,' ')
        bpnum = parse(Int, fields[2][1:end-1])
        recipes = [Recipe(fields[rng]) for rng in [3:8,9:14,15:23,24:32]]
        push!(recipes,Recipe())
        push!(bps,recipes)
    end
    bps
end

# States
struct State
    state::Vector{Int}
end

State() = State([0,0,0,0,1,0,0,0])  # Start with 1 ore robot, nothing else
Base.:+(st::State,rec::Recipe) = State(st.state .+ rec.rec)
legal(st::State) = reduce(&,st.state .>= 0)

Base.:>=(a::State, b::State) = reduce(&,a.state.>=b.state)
Base.:<=(a::State, b::State) = reduce(&,a.state.<=b.state)

# State processing
function gen_newstates(st::State, bp::Vector{Recipe})
    growth = Recipe([st.state[5:8];zeros(Int,4)])
    newstates = filter(legal,Ref(st) .+ bp)
    newstates = newstates[1:min(4,length(newstates))]  # if we can build, then force a build
    newstates .+ Ref(growth)
end

function eval_states(newstates::Vector{State}, next_phase::Vector{State})
    for newstate in newstates
        flag = true
        for (num, st) in enumerate(next_phase)
            if st >= newstate
                flag = false
                # println("cut one")
                break
            elseif st <= newstate
                next_phase[num] = newstate
                flag = false
                # println("cut two")
                break
            end
        end
        if flag
            push!(next_phase, newstate)
        end
    end
    next_phase
end

function eval_states2(newstates::Vector{State}, next_phase::Vector{State})
    np = next_phase
    for newstate in newstates
        flag = true
        for st in np
            if st >= newstate
                flag = false
                break
            end
        end
        if ~flag
            continue
        end
        filter!(x -> ~(newstate >= x),np)
        push!(np, newstate)
    end
    np
end

function run_cycle(current_states::Vector{State}, bp::Vector{Recipe},cycle,max_cycles)
    next_phase = Vector{State}()

    if cycle <= max_cycles-3
        bp_reduced = bp
    elseif cycle == max_cycles-2
        bp_reduced = bp[[1,3,4,5]]
    elseif cycle == max_cycles-1
        bp_reduced = bp[[4,5]]
    elseif cycle == max_cycles
        bp_reduced = bp[[5]]
    end
    for state in current_states
        newstates = gen_newstates(state,bp_reduced)
        if cycle <= max_cycles-6
            next_phase = eval_states2(newstates, next_phase)
        else
            append!(next_phase,newstates)
        end
    end
    next_phase
end

function max_field(states::Vector{State}, field::Int)
    fn(st) = st.state[field]
    maximum(fn.(states))
end

function run_bp(bp,max_cycles)
    current_states = [State()]
    for cycle in 1:max_cycles
        next_state = run_cycle(current_states,bp,cycle,max_cycles);
        current_states = next_state;
        println("Cycle $cycle:\tGeodes:$(max_field(current_states,4))\t:Num states: $(length(current_states))")
    end
    max_field(current_states,4)
end


## Run the program

bps = load_blueprints(("advent19.test","advent19.input")[2])
max_cycles = 24

println("Threads -- using $(Threads.nthreads())")
stats = []
Threads.@threads for num in 1:length(bps)
    push!(stats,(num,run_bp(bps[num],max_cycles)))
    println("==============================================================")
    println("Stats #$num")
    println(stats)
    println("==============================================================")
end

stats = Array([(15,14), (22,15), (16,5), (23,0), (1, 0), (17, 1), (24, 2), (25, 0), (26, 1), 
(2, 2), (9, 1), (3, 3), (4, 1), (5, 0), (6, 0), (18, 1), (19, 1), (20, 5), (27, 9), (21, 4), 
(7, 2), (8, 0), (10, 5), (11, 0), (12, 0), (13, 0), (28, 8), (29, 0), (30, 5), (14, 3)])

score = reduce(+,reduce.(*,stats))

max_cycles = 32
stats = []
Threads.@threads for num in 1:3
    push!(stats,(num,run_bp(bps[num],max_cycles)))
    println("==============================================================")
    println("Stats #$num")
    println(stats)
    println("==============================================================")
end

stats = [(1,6), (2,31), (3,)]