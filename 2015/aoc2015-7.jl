import Base.isinteger
isinteger(x) = false

function eval_node(ckt, nodename)
    # println(typeof(nodename),nodename)

    if nodename[1] in '0':'9'
        tmp = parse(UInt16, nodename)
        ckt[nodename] = tmp
        return tmp
    end
    node = ckt[nodename]

    if isinteger(node)
        return node
    end
    if length(node) == 1
        if node[1][1] in '0':'9'
            tmp = parse(UInt16,node[1])
            ckt[nodename] = tmp
            return tmp
        else
            tmp = eval_node(ckt,node[1])
            ckt[nodename] = tmp
            return tmp
        end
    elseif length(node) == 2
        return ~eval_node(ckt,node[2])
    else
        if node[2] == "AND"
            tmp = eval_node(ckt,node[1]) & eval_node(ckt,node[3])
            ckt[nodename] = tmp
            return tmp
        elseif node[2] == "OR"
            tmp = eval_node(ckt,node[1]) | eval_node(ckt,node[3])
            ckt[nodename] = tmp
            return tmp
        elseif node[2] == "LSHIFT"
            tmp = eval_node(ckt,node[1]) << parse(Int,node[3]) # eval_node(ckt,node[3])
            ckt[nodename] = tmp
            return tmp
        elseif node[2] == "RSHIFT"
            tmp = eval_node(ckt,node[1]) >> parse(Int,node[3]) # eval_node(ckt,node[3])
            ckt[nodename] = tmp
            return tmp
        else
            println("Error")
        end
    end
end

circuit = Dict()
for line in readlines("input2015-7.txt")
    definition, name = split(line, "->")
    circuit[lstrip(name)] = split(rstrip(definition)," ")
end
println(eval_node(circuit,"a"))
saved = circuit["a"]

circuit = Dict()
for line in readlines("input2015-7.txt")
    definition, name = split(line, "->")
    circuit[lstrip(name)] = split(rstrip(definition)," ")
end
circuit["b"] = saved
println(eval_node(circuit,"a"))
