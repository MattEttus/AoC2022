
circuit = Dict()

for line in readlines(["test2015-7.txt","input2015-7.txt"][2])
    definition, name = split(line, "->")
    circuit[lstrip(name)] = split(rstrip(definition)," ")
end

function eval_node(ckt, nodename)
    println(typeof(nodename),nodename)

    if nodename[1] in '0':'9'
        return parse(UInt16, nodename)
    end
    node = ckt[nodename]
    if length(node) == 1
        if node[1][1] in '0':'9'
            return parse(UInt16,node[1])
        else
            tmp = eval_node(ckt,node[1])
            circuit[nodename] = string(tmp)
            return tmp
        end
    elseif length(node) == 2
        return ~eval_node(ckt,node[2])
    else
        if node[2] == "AND"
            return eval_node(ckt,node[1]) & eval_node(ckt,node[3])
        elseif node[2] == "OR"
            return eval_node(ckt,node[1]) | eval_node(ckt,node[3])
        elseif node[2] == "LSHIFT"
            return eval_node(ckt,node[1]) << parse(Int,node[3]) # eval_node(ckt,node[3])
        elseif node[2] == "RSHIFT"
            return eval_node(ckt,node[1]) >> parse(Int,node[3]) # eval_node(ckt,node[3])
        else
            println("Error")
        end
    end
end

println(eval_node(circuit,"a"))