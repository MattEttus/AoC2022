
mutable struct WeirdNum
    residuals::Dict{Int,Int}
end

WeirdNum(num,bases) = WeirdNum(Dict([(base, num % base) for base in bases]))

function Base.:+(x::WeirdNum,y::Int)
    WeirdNum(Dict([(base,(value+y)%base) for (base, value) in x.residuals]))
end

function Base.:*(x::WeirdNum,y::Int)
    WeirdNum(Dict([(base,(value*y)%base) for (base, value) in x.residuals]))
end

function Base.:%(x::WeirdNum,y::Int)
    x.residuals[y]
end

function Base.:*(x::WeirdNum,y::WeirdNum)
    WeirdNum(Dict([(base,(value*y.residuals[base])%base) for (base, value) in x.residuals]))
end
