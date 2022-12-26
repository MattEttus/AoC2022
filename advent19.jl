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

function run_cycle(current_states::Vector{State}, bp::Vector{Recipe})
    next_phase = Vector{State}()
    for state in current_states
        newstates = gen_newstates(state,bp)
        next_phase = eval_states(newstates, next_phase)
    end
    next_phase
end

function max_field(states::Vector{State}, field::Int)
    fn(st) = st.state[field]
    maximum(fn.(states))
end

## Run the program

bps = load_blueprints(("advent19.test","advent19.input")[1])
bp = bps[1]
st = State()
current_states = [st]

for cycle in 1:24
    next_state = run_cycle(current_states,bp);
    current_states = next_state;
    println("Cycle $cycle:\tGeodes:$(max_field(current_states,4))\t:Num states: $(length(current_states))")
end