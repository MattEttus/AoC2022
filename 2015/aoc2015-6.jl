
import Base.parse

function parse(CartesianIndex,str)
    CartesianIndex(parse.(Int,split(str,","))...)
end

function iter(a::CartesianIndex, b::CartesianIndex)
    #l = Array{CartesianIndex}[]
    l = []
    for r in min(a[1],b[1]):max(a[1],b[1])
        for c in min(a[2],b[2]):max(a[2],b[2])
            push!(l,CartesianIndex(r,c))
        end
    end
    l
end

# Part 1
leds = zeros(Bool,1000,1000)
set(x) = true
unset(x) = false
toggle(x) = ~x

# Part 2
leds = zeros(Int,1000,1000)
set(x) = x + 1
unset(x) = max(0,x - 1)
toggle(x) = x + 2

for line in readlines("input2015-6.txt")
    tokens = split(line, " ")
    if length(tokens) == 5
        tokens = tokens[2:end]
    end
    if tokens[1] == "on"
        fun = set
    elseif tokens[1] == "off"
        fun = unset
    else
        fun = toggle
    end
    for idx in iter(parse(CartesianIndex,tokens[2]),parse(CartesianIndex,tokens[4]))
        leds[idx] = fun(leds[idx])
    end
end
println(sum(leds))