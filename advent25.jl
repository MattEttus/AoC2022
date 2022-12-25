
convert_from_res5(x::Char) = Dict([('2',2),('1',1),('0',0),('-',-1),('=',-2)])[x]

function convert_from_res5(x::String)
    if length(x) == 0
        return 0
    else
        return convert_from_res5(x[end]) + 5 *convert_from_res5(x[1:end-1])
    end
end

function cvt5(x::Int)
    y = 1
    while x >= 5*y
        y *= 5
    end
    z = x
    vec = []
    while y>0
        push!(vec,z ÷ y)
        z -= (z ÷ y) * y
        y ÷= 5
    end
    vec
end

function cvtbal(vec, str="")
    if vec == []
        println()
        return
    end
    if vec[1] > 2
        if length(vec) == 1
            push!(vec,0)
        end
        vec[1] -= 5
        vec[2] += 1
        cvtbal(vec)
    elseif vec[1] < -2
        if length(vec) == 1
            push!(vec,0)
        end
        vec[1] += 5
        vec[2] -= 1
        cvtbal(vec)
    else
        print(Dict([(2,"2"),(1,"1"),(0,"0"),(-1,"-"),(-2,"=")])[vec[1]])
        cvtbal(vec[2:end])
    end
end


filename = ("advent25.test","advent25.input")[1]

total = sum([convert_from_res5(line) for line in readlines(filename)])
