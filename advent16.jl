# State is valve states, completed flow, current location.  Time is implicit
struct State
    flow::Int
    loc::Int
    valves::Vector{Bool}
end

Base.:>=(a::State, b::State) = (a.loc==b.loc) && (a.flow >= b.flow) && (reduce(&,a.valves .>= b.valves))

function load_map(filename)
    tunnels = Vector{Vector{Int}}()
    names = Dict{String,Int}()
    flow_rates = [] #Vector{Int}[]
    init_valves = [] #Vector{Bool}[]

    for (num, line) in enumerate(readlines(filename))
        tokens = split(line," ")
        names[tokens[2]] = num
        # println(parse(Int,tokens[5][6:end-1]))
        push!(flow_rates,parse(Int,tokens[5][6:end-1]))
        push!(init_valves,flow_rates[end] == 0)
    end
    Initial_State = State(0,names["AA"],init_valves)

    # 2nd pass to make map
    for line in readlines(filename)
        tokens = split(line," ")[10:end]
        push!(tunnels,[names[token[1:2]] for token in tokens])
    end
    return names, flow_rates, Initial_State, tunnels
end

function gen_moves(state,flow_rates, tunnels) #::State, flow_rates, tunnels)
    moves = [] # Vector{State}[]
    flow = state.flow + sum(state.valves .* flow_rates)
    # First try turning on a valve
    if ~state.valves[state.loc]
        new_valves=copy(state.valves)
        new_valves[state.loc] = true
        push!(moves,State(flow,state.loc,new_valves))
    end
    for tunnel in tunnels[state.loc]
        push!(moves,State(flow,tunnel,state.valves))
    end
    moves
end

function eval_moves(moves,states) #::Vector{State}, states::Vector{State})
    for move in moves
        flag = true
        for (num,st) in enumerate(states)
            if st >= move
                flag = false
                break
            elseif move >= st
                states[num] = move
                flag = false
                break
            end
        end
        if flag
            push!(states, move)
        end
    end
    states
end

function max_flow(states)
    fn(st) = st.flow
    maximum(fn.(states))
end

names, flow_rates, Initial_State, tunnels = load_map(("advent16.test","advent16.input")[2])

cur_states = [Initial_State]
for cycle in 1:30
    next_states = []
    for cur_state in cur_states
        moves = gen_moves(cur_state, flow_rates, tunnels)
        next_states = eval_moves(moves, next_states)
    end
    cur_states = next_states
    println("Cycle $cycle: Num states: $(length(cur_states))  Best Flow: $(max_flow(cur_states))")
end

cur_states