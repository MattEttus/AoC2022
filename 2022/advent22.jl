function wrap(pos,dir,lim)
    if dir == 0
        CartesianIndex(pos[1],1)
    elseif dir == 1
        CartesianIndex(1,pos[2])
    elseif dir == 2
        CartesianIndex(pos[1],lim[2])
    else
        CartesianIndex(lim[1],pos[2])
    end
end

function read_input(filename)
    points = Dict{CartesianIndex,Bool}()
    rows = 0
    columns = 0

    for (row,line) in enumerate(readlines(filename))
        if length(line) == 0
            rows = row-1
            break
        end
        columns = max(columns, length(line))
        for (column,char) in enumerate(line)
            if char == '#'
                points[CartesianIndex(row,column)] = true
            elseif char == '.'
                points[CartesianIndex(row,column)] = false
            end
        end
    end
    lim = CartesianIndex(rows,columns);
    commands = readlines(filename)[rows+2];
    return lim, commands, points
end

function run_commands(lim,commands,points)
    # right, down, left, up
    move = Dict([(0,CartesianIndex(0,1)),(1,CartesianIndex(1,0)),(2,CartesianIndex(0,-1)),(3,CartesianIndex(-1,0))]);

    pos = CartesianIndex(1,1);
    while ~(pos in keys(points)) || points[pos] == true
        pos += CartesianIndex(0,1)
    end

    dir = 0;
    num_start = 1;
    num_finish = 1;

    while num_finish <= length(commands)
        while num_finish < length(commands) && commands[num_finish+1] in "0123456789"
            num_finish +=1
        end
        count = parse(Int,commands[num_start:num_finish])
        for i in 1:count
            if pos+move[dir] in keys(points)
                if points[pos+move[dir]]
                    break
                else
                    pos += move[dir]
                end
            else
                new_p = wrap(pos,dir,lim)
                # print("wrapped: ",new_p)
                while new_p ∉ keys(points)
                    new_p += move[dir]
                end
                if points[new_p] == false
                    pos = new_p
                else
                    break
                end
            end
        end
        if num_finish == length(commands)
            break
        end
        if commands[num_finish+1] == 'R'
            dir = (dir + 1) % 4
        else
            dir = (dir + 3) % 4
        end
        num_start = num_finish + 2
        num_finish = num_start
    end
    return pos,dir
end

filename = ("advent22.test","advent22.input")[2]
(lim, commands, points) = read_input(filename);
(pos, dir) = run_commands(lim, commands, points)
println("Part 1: $(1000*pos[1]+4*pos[2]+dir)")