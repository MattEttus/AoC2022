
function value(tree,key) 
    node = tree[key]
    if typeof(node) <: Number
        return node
    else
        return node[1](value(tree,node[2]),value(tree,node[3]))
    end
end

tree = Dict{String,Union{Int,Tuple}}()

for monkey in readlines(("advent21.test","advent21.input")[2])
    key = monkey[1:4]
    if monkey[7] in 'a':'z'
        spl = split(monkey[7:end]," ")
        tree[key] = (eval(Meta.parse(spl[2])),spl[1],spl[3])
    else
        tree[key] = parse(Int, monkey[7:end])
    end
end

println("Part 1: $(Int(value(tree,"root")))")

using SymPy
@vars humn

tree = Dict()

for monkey in readlines(("advent21.test","advent21.input")[2])
    key = monkey[1:4]
    if key == "humn"
        tree[key] = humn
        continue
    end
    if monkey[7] in 'a':'z'
        spl = split(monkey[7:end]," ")
        tree[key] = (eval(Meta.parse(spl[2])),spl[1],spl[3])
    else
        tree[key] = parse(Int, monkey[7:end])
    end
end

side_a = value(tree,tree["root"][2])
side_b = value(tree,tree["root"][3])

println("Part 2: $(solve(side_a-side_b,humn)[1])")