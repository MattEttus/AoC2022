
lines = readlines("advent9.test")
lines = readlines("advent9.test2")
lines = readlines("advent9.input")

rope_len = 10

rope = [(0,0) for i in 1:rope_len]

tail_pos = Set()

push!(tail_pos,rope[rope_len])

function move_tail(head, tail)
    if reduce(&, abs.(head .- tail) .< 2)
        return tail
    # elseif sum(abs.(head .- tail)) > 3
    #     println("Really weird: ",head, " ", tail)
    elseif head[1] == tail[1] || head[2] == tail[2]
        return ((head[1]+tail[1]) ÷ 2, (head[2]+tail[2]) ÷ 2)
    else
        return tail .+ sign.(head.-tail)
    end
end

function move_head(head,dir)
    if dir == 'L'
        return (head[1]-1,head[2])
    elseif dir == 'R'
        return (head[1]+1,head[2])
    elseif dir == 'U'
        return (head[1],head[2]-1)
    else # 'D'
        return (head[1],head[2]+1)
    end
end


for line in lines
    for iter in 1:parse(Int, line[3:end])
        rope[1] = move_head(rope[1],line[1])
        for knot in 1:rope_len-1
            rope[knot+1] = move_tail(rope[knot],rope[knot+1])
        end
        push!(tail_pos, rope[rope_len])
    end
end

print(length(tail_pos))   # 13, then 6181