
function compare(l1::Vector,l2::Vector)
    if length(l1) == 0 && length(l2) == 0
        0
    elseif length(l1) == 0
        1
    elseif length(l2) == 0
        -1
    else
        cmp = compare(l1[1],l2[1])
        if cmp != 0
            cmp
        else
            compare(l1[2:end],l2[2:end])
        end
    end
end

function compare(l1::Int,l2::Int)
    if l1 < l2
        1
    elseif l1 > l2
        -1
    else
        0
    end
end

function compare(l1::Int,l2::Vector)
    compare([l1],l2)
end

function compare(l1::Vector,l2::Int)
    compare(l1,[l2])
end

filename = ["advent13.test", "advent13.input"][2]
file = open(filename)

# Part 1
pair = 1
total = 0
while ~eof(file)
    list1 = eval(Meta.parse(readline(file)))
    list2 = eval(Meta.parse(readline(file)))
    _ = readline(file)  # grab blank line
    println("Pair $pair: ", compare(list1,list2))
    if compare(list1,list2) == 1
        total += pair
    end
    pair += 1
end

println(total)

function lt(a,b)
    if compare(a,b) == 1
        return true
    else
        return false
    end
end

# Part 2
lol = []
while ~eof(file)
    push!(lol,eval(Meta.parse(readline(file))))
    push!(lol,eval(Meta.parse(readline(file))))
    _ = readline(file)  # grab blank line
end
push!(lol,[[2]])
push!(lol,[[6]])

p = sortperm(lol,lt=lt)

println(findfirst(==(length(lol)),p) * findfirst(==(length(lol)-1),p))
