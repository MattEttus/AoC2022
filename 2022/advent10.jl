
lines = readlines("advent10.test")
lines = readlines("advent10.input")

cycle = 1
v = 1
stored_v = []
phase = 0
pc = 0
delta_v = 0

while pc < length(lines)

    if phase == 0
        pc += 1
        v += delta_v
        if lines[pc][1:4] == "addx"
            delta_v = parse(Int, lines[pc][6:end])
            phase = 1
        else
            delta_v = 0
        end
    else
        phase = 0  # noop
    end
    if (cycle - 20) % 40 == 0
        push!(stored_v, v*cycle)
    end
    if abs(v - (cycle%40-1)) < 2
        print("#")
    else
        print(".")
    end
    if cycle % 40 == 0
        println()
    end    
    # println(cycle,":\tV:",v,"\tPC: ", pc, "\tPHASE: ", phase,"\tINS: ", lines[pc])
    cycle += 1
end

stored_v
sum(stored_v)