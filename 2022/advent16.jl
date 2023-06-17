# advent16.jl

# Routing algorithms
using Memoize

function make_dist_map(tunnels)
    dist = fill(10000,length(tunnels),length(tunnels))
    for (src,dsts) in enumerate(tunnels)
        for dst in dsts
            dist[src,dst] = 1
        end
    end
    for i in 1:length(tunnels)
        dist[i,i] = 0
    end
    flag = true
    while flag
        flag = false
        for src in 1:length(tunnels)
            for dst in 1:length(tunnels)
                for via in 1:length(tunnels)
                    if dist[src,via] + dist[via,dst] < dist[src,dst]
                        dist[src,dst] = dist[src,via] + dist[via,dst]
                        flag = true
                    end
                end
            end
        end
    end
    dist
end

@memoize function route_step(src,dst,dist)
    best = 0
    min_dist = 1000
    for next in 1:size(dist)[1]
        if dist[src,next] == 1
            if dist[next,dst] < min_dist
                min_dist = dist[next,dst]
                best = next
            end
        end
    end
    best
end

function print_route(src,dst,dist)
    while src != dst
        src = route_step(src,dst,dist)
        print(src, ", ")
    end
end

# State is valve states, completed flow, current location.  Time is implicit
struct State
    flow::Int
    loc::Int
    goal::Int
    loc_elephant::Int
    goal_elephant::Int
    valves::Vector{Bool}
end

same_loc(a::State, b::State) = ((a.loc == b.loc) && (a.loc_elephant == b.loc_elephant)) # || ((a.loc == b.loc_elephant) && (a.loc_elephant == b.loc))
same_goal(a::State, b::State) = ((a.goal == b.goal) && (a.goal_elephant == b.goal_elephant))
all_on(a::State) = reduce(&,a.valves)

function Base.:>=(a::State, b::State)
    if all_on(a) && a.flow >= b.flow
        return true
    else
        same_loc(a,b) && same_goal(a,b) && (a.flow >= b.flow) && (reduce(&,a.valves .>= b.valves))
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
        push!(flow_rates,parse(Int,tokens[5][6:end-1]))
        push!(init_valves,flow_rates[end] == 0)
    end
    Initial_State = State(0,names["AA"],0,names["AA"],0,init_valves)

    # 2nd pass to make map
    for line in readlines(filename)
        tokens = split(line," ")[10:end]
        push!(tunnels,[names[token[1:2]] for token in tokens])
    end
    return names, flow_rates, Initial_State, tunnels
end

function gen_moves(state,flow_rates,dist,use_elephant=false) #::State, flow_rates, tunnels)
    flow = state.flow + sum(state.valves .* flow_rates)
    if all_on(state)
        [State(flow,state.loc,0,state.loc_elephant,0,state.valves)]
    else
        moves = []
        if use_elephant
            el_moves =  gen_moves2(state,dist)
        else
            el_moves = [state]
        end
        for el_move in el_moves
            if all_on(el_move)
                push!(moves,State(flow,el_move.loc,0,el_move.loc_elephant,0,el_move.valves))
            elseif el_move.goal == 0 || el_move.valves[el_move.goal]
                # Either goal accomplished or other guy got there first  
                append!(moves,[State(flow,route_step(el_move.loc,goal,dist),goal,el_move.loc_elephant,el_move.goal_elephant,el_move.valves) for goal in findall(y -> ~y, el_move.valves)])
            elseif el_move.goal == el_move.loc
                # Arrived at our goal, open the valve
                new_valves=copy(el_move.valves)
                new_valves[el_move.goal] = true
                push!(moves,State(flow,el_move.loc,0,el_move.loc_elephant,el_move.goal_elephant,new_valves))
            else
                push!(moves,State(flow,route_step(el_move.loc,el_move.goal,dist),el_move.goal,el_move.loc_elephant,el_move.goal_elephant,el_move.valves))
            end
        end
        moves
    end
end

function gen_moves2(state,dist) #::State, flow_rates, tunnels)
    if state.goal_elephant == 0 || state.valves[state.goal_elephant]
        # Either goal accomplished or other guy got there first
        if all_on(state)
            # All valves open, just stay still
            [State(state.flow,state.loc,state.goal,state.loc_elephant,0,state.valves)]
        else
            # generate a move towards each valve which is still off
            [State(state.flow,state.loc,state.goal,route_step(state.loc_elephant,goal,dist),goal,state.valves) for goal in findall(y -> ~y, state.valves)]
        end
    elseif state.goal_elephant == state.loc_elephant
        # Arrived at goal, let's open the valve
        new_valves=copy(state.valves)
        new_valves[state.goal_elephant] = true
        [State(state.flow,state.loc,state.goal,state.loc_elephant,0,new_valves)]
    else
        # Keep going towards goal
        [State(state.flow,state.loc,state.goal,route_step(state.loc_elephant,state.goal_elephant,dist), state.goal_elephant,state.valves)]
    end
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

function eval_moves3(moves,states)

end

function max_flow(states)
    fn(st) = st.flow
    maximum(fn.(states))
end

function run_sim(Initial_State,flow_rates,dist,cycles,elephant)
    cur_states = [Initial_State]
    for cycle in 1:cycles
        moves = []
        for cur_state in cur_states
            append!(moves,gen_moves(cur_state, flow_rates, dist, elephant))
        end
        cur_states = moves
        #cur_states = eval_moves2(moves, [])
        println("Cycle $cycle: Num states: $(length(cur_states))  Best Flow: $(max_flow(cur_states))")
    end
    max_flow(cur_states)
end

names, flow_rates, Initial_State, tunnels = load_map(("advent16.test","advent16.input")[2])
dist = make_dist_map(tunnels)

println("Part 1: Max Flow = $(run_sim(Initial_State,flow_rates,dist,30,false))")
println("Part 2: Max Flow = $(run_sim(Initial_State,flow_rates,dist,26,true))")