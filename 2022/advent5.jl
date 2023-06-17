
using DataStructures

lines = readlines("advent5.input")
lines = readlines("advent5.test")

numstacks = 0
maxheight = 0
for (linenum, line) in enumerate(lines)
    if line == ""
        maxheight = linenum - 2
        numstacks = parse(Int,split(lines[linenum-1],' ',keepempty=false)[end])
        break
    end
end

stacks = Array{Stack{Char}}(undef,numstacks)
for i in 1:numstacks
    stacks[i] = Stack{Char}()
end

for i in maxheight:-1:1
    boxes = lines[i][2:4:end]
    for j in 1:length(boxes)
        if boxes[j] != ' '
            push!(stacks[j],boxes[j])
        end
    end
end

# Part 1
for line in lines[maxheight+3:end]
    (_,count,_,src,_,dst) = split(line,' ')
    println(line)
    for i in 1:parse(Int,count)
        push!(stacks[parse(Int,dst)],pop!(stacks[parse(Int,src)]))
    end
end

# Part 2 -- Kind of ugly and inefficient
tmpstack = Stack{Char}()
for line in lines[maxheight+3:end]
    (_,count,_,src,_,dst) = split(line,' ')
    println(line)
    for i in 1:parse(Int,count)
        push!(tmpstack,pop!(stacks[parse(Int,src)]))
    end
    for i in 1:parse(Int,count)
        push!(stacks[parse(Int,dst)],pop!(tmpstack))
    end
end

for stack in stacks
    print(first(stack))
end
println()