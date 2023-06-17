# operation = Meta.parse(split(readline(fp),":")[2])
# operation = eval(Meta.parse("fn(old) = " * split(readline(fp),"=")[2]))

include("WeirdNums.jl")

mutable struct Monkey
    number::Int
    items::Array{}
    operation
    test
    inspections::Int
end

function get_bases(fp)
    bases = []
    while ~eof(fp)
        line = readline(fp)
        if occursin("divisible",line)
            push!(bases,parse(Int,split(line,"by")[2]))
        end
    end
    bases
end

function Monkey(fp,bases)
    line = ""
    while ~eof(fp) && ~startswith(line, "Monkey")
        line = readline(fp)
    end
    number = parse(Int, split(line," ")[2][1:end-1])
    println("Processing monkey #", number)
    items = eval(Meta.parse("["*split(readline(fp),":")[2]*"]"))
    items_weird = WeirdNum.(items,[bases])
    
    fn_def = "fn$number(old) = " * split(readline(fp),"=")[2]
    println("operation will be: ", fn_def)
    operation = eval(Meta.parse(fn_def))
    
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
    Monkey(number,items_weird,operation,test, 0)
end

function round(monkeys, num_monkeys)
    for num in 0:num_monkeys-1
        monkey = monkeys[num]
        while ~isempty(monkey.items)
            monkey.inspections += 1
            item = popfirst!(monkey.items)
            newitem = monkey.operation(item) #÷ 3  Change for first half
            push!(monkeys[monkey.test(newitem)].items,newitem)
        end
    end
end

filename = ("advent11.test", "advent11.input")[2]

file = open(filename)
bases = get_bases(file)

file = open(filename)
monkeys = Dict()
while ~eof(file)
    monkey = Monkey(file,bases)
    monkeys[monkey.number] = monkey
end

num_monkeys = length(monkeys)

for i in 0:num_monkeys-1
    println(i,": ", monkeys[i].items)
end

for i in 1:10000
    round(monkeys, num_monkeys)
end

insp = []
for i in 0:num_monkeys-1
    println(i,": ", monkeys[i].inspections,"\t",monkeys[i].items)
    push!(insp,monkeys[i].inspections)
end

reduce(*, sort(insp,rev=true)[1:2])
