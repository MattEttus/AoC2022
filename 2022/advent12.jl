using DataStructures

filename = ["advent12.test", "advent12.input"][2]

lines = readlines(filename)
hmap = reduce(vcat, permutedims.(collect.(lines)))

start = findfirst(hmap .== 'S')
finish = findfirst(hmap .== 'E')

hmap[start] = 'a'
hmap[finish] = 'z'

stepmap = fill(length(hmap)+1,size(hmap))

solutions = []

path = Stack{CartesianIndex}()

function try_move(hmap, stepmap, stepcount, pos, path, solutions, finish)
    stepmap[pos] = stepcount
    push!(path,pos)
    if pos == finish
        println("Found a path in $stepcount steps!")
        # println(path)
        # push!(solutions,copy(path))
        pop!(path)
        return
    end
    if pos[1] > 1
        new_pos = CartesianIndex(pos[1]-1,pos[2])
        if hmap[new_pos] <= hmap[pos] + 1 && stepmap[new_pos] > stepcount + 1
            try_move(hmap, stepmap, stepcount + 1, new_pos, path, solutions, finish)
        end
    end
    if pos[1] < size(hmap)[1]
        new_pos = CartesianIndex(pos[1]+1,pos[2])
        if hmap[new_pos] <= hmap[pos] + 1 && stepmap[new_pos] > stepcount + 1
            try_move(hmap, stepmap, stepcount + 1, new_pos, path, solutions, finish)
        end
    end
    if pos[2] > 1
        new_pos = CartesianIndex(pos[1],pos[2]-1)
        if hmap[new_pos] <= hmap[pos] + 1 && stepmap[new_pos] > stepcount + 1
            try_move(hmap, stepmap, stepcount + 1, new_pos, path, solutions, finish)
        end
    end
    if pos[2] < size(hmap)[2]
        new_pos = CartesianIndex(pos[1],pos[2]+1)
        if hmap[new_pos] <= hmap[pos] + 1 && stepmap[new_pos] > stepcount + 1
            try_move(hmap, stepmap, stepcount + 1, new_pos, path, solutions, finish)
        end
    end
    pop!(path)
    return
end

try_move(hmap,stepmap,0,start,path,solutions,finish)

for startpt in findall(==('a'),hmap)
    try_move(hmap,stepmap,0,startpt,path,solutions,finish)
end
