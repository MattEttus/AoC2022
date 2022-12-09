
lines = readlines("advent9.test")
lines = readlines("advent9.input")

rope_len = 2

rope = [(0,0) for i in 1:rope_len]

tail_pos = Set()

push!(tail_pos,(tail_r,tail_c))

function move_tail(head, tail)
    if reduce(&, abs.(head .- tail) .< 2)
        return tail  # close enough, don't move
    elseif head[1] == tail[1] || head[2] == tail[2]
        return ((head[1]+tail[1]) ÷ 2, (head[2]+tail[2]) ÷ 2)
    else
        if abs(head[1] - tail[1]) == 2
            return ((head[1]+tail[1]) ÷ 2, head[2])
        elseif abs(head[2] - tail[2]) == 2
            return (head[1], (head[2]+tail[2]) ÷ 2)
        else
            println("WEIRD!!!!")
        end
    end
end

for line in lines
    dir = line[1]
    count = parse(Int, line[3:end])
    println(dir,":",count)
    if dir == 'L'
        for iter in 1:count
            head_c += -1
            (tail_r, tail_c) = move_tail((head_r,head_c),(tail_r,tail_c))
            push!(tail_pos, (tail_r, tail_c))
        end
    elseif dir == 'R'
        for iter in 1:count
            head_c += 1
            (tail_r, tail_c) = move_tail((head_r,head_c),(tail_r,tail_c))
            push!(tail_pos, (tail_r, tail_c))
        end
    elseif dir == 'U'
        for iter in 1:count
            head_r += -1
            (tail_r, tail_c) = move_tail((head_r,head_c),(tail_r,tail_c))
            push!(tail_pos, (tail_r, tail_c))
        end
    elseif dir == 'D'
        for iter in 1:count
            head_r += 1
            (tail_r, tail_c) = move_tail((head_r,head_c),(tail_r,tail_c))
            push!(tail_pos, (tail_r, tail_c))
        end
    end
end

print(length(tail_pos))   # 13, then 6181