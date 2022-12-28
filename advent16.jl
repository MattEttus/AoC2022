# State is valve states, completed flow, current location.  Time is implicit
struct State
    flow::Int
    loc::Int
    loc_elephant::Int
    valves::Vector{Bool}
end

same_loc(a::State, b::State) = ((a.loc == b.loc) && (a.loc_elephant == b.loc_elephant)) || ((a.loc == b.loc_elephant) && (a.loc_elephant == b.loc))

all_on(a::State) = reduce(&,a.valves)

function Base.:>=(a::State, b::State)
    if all_on(a) && a.flow >= b.flow
        return true
    else
        same_loc(a,b) && (a.flow >= b.flow) && (reduce(&,a.valves .>= b.valves))
    end
end

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
    Initial_State = State(0,names["AA"],names["AA"],init_valves)

    # 2nd pass to make map
    for line in readlines(filename)
        tokens = split(line," ")[10:end]
        push!(tunnels,[names[token[1:2]] for token in tokens])
    end
    return names, flow_rates, Initial_State, tunnels
end

function gen_moves(state,flow_rates,tunnels) #::State, flow_rates, tunnels)
    moves = [] # Vector{State}[]
    flow = state.flow + sum(state.valves .* flow_rates)
    if all_on(state)
        return [State(flow,state.loc,state.loc_elephant,state.valves)]
    end
    for el_move in gen_moves2(state,flow_rates,tunnels)
        # First try turning on a valve
        if ~el_move.valves[state.loc]
            new_valves=copy(el_move.valves)
            new_valves[state.loc] = true
            push!(moves,State(flow,state.loc,el_move.loc_elephant,new_valves))
        end
        for tunnel in tunnels[state.loc]
            push!(moves,State(flow,tunnel,el_move.loc_elephant,el_move.valves))
        end
    end
    moves
end

function gen_moves2(state,flow_rates,tunnels) #::State, flow_rates, tunnels)
    moves = [] # Vector{State}[]
    
    # First try turning on a valve
    if ~state.valves[state.loc_elephant]
        new_valves=copy(state.valves)
        new_valves[state.loc_elephant] = true
        push!(moves,State(state.flow,state.loc,state.loc_elephant,new_valves))
    end
    for tunnel in tunnels[state.loc_elephant]
        push!(moves,State(state.flow,state.loc,tunnel,state.valves))
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

function eval_moves2(moves,states) #::Vector{State}, states::Vector{State})
    for move in moves
        flag = true
        for st in states
            if st >= move
                flag = false
                break
            end
        end
        if ~flag
            continue
        end
        states = filter(x -> ~(move >= x), states)
        push!(states, move)
    end
    states
end

function max_flow(states)
    fn(st) = st.flow
    maximum(fn.(states))
end

names, flow_rates, Initial_State, tunnels = load_map(("advent16.test","advent16.input")[2])
cur_states = [Initial_State]

# for cycle in 1:26
#     next_states = []
#     for cur_state in cur_states
#         moves = gen_moves(cur_state, flow_rates, tunnels)
#         next_states = eval_moves2(moves, next_states)
#     end
#     cur_states = next_states
#     println("Cycle $cycle: Num states: $(length(cur_states))  Best Flow: $(max_flow(cur_states))")
# end

for cycle in 1:26
    moves = []
    for cur_state in cur_states
        append!(moves,gen_moves(cur_state, flow_rates, tunnels))
    end
    global cur_states = eval_moves2(moves, [])
    println("Cycle $cycle: Num states: $(length(cur_states))  Best Flow: $(max_flow(cur_states))")
end