
file = open("advent11.test")
file = open("advent11.input")

mutable struct Monkey
    number::Int
    items::Array{Int}
    operation
    test
    inspections::Int
end

function Monkey(fp)
    line = ""
    while ~eof(fp) && ~startswith(line, "Monkey")
        line = readline(fp)
    end
    number = parse(Int, split(line," ")[2][1:end-1])
    println("Processing monkey #", number)
    items = eval(Meta.parse("["*split(readline(fp),":")[2]*"]"))
    operation = Meta.parse(split(readline(fp),":")[2])
    factor = parse(Int,split(readline(fp),"by")[2])
    
    line1 = split(readline(file)," ",keepempty=false)
    line2 = split(readline(file)," ",keepempty=false)
    
    function test(x)
        if (x % factor == 0) == Meta.parse(line1[2][1:end-1])
            parse(Int,line1[6])
        else
            parse(Int,line2[6])
        end
    end 
    Monkey(number,items,operation,test, 0)
end

monkeys = Dict()
while ~eof(file)
    monkey = Monkey(file)
    monkeys[monkey.number] = monkey
end

num_monkeys = length(monkeys)

# Do a round
function round(monkeys, num_monkeys)
    for num in 0:num_monkeys-1
        monkey = monkeys[num]
        while ~isempty(monkey.items)
            old = popfirst!(monkey.items)
            println(old)
            push!(monkeys[monkey.test(eval(monkey.operation))],new)
            # push!(monkeys[monkey.test(eval(monkey.operation))],new)
        end
    end
end

round(monkeys, num_monkeys)

for i in 0:num_monkeys-1
    println(i,": ", monkeys[i].items)
end