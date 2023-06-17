
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
        return str
    end
    if vec[1] > 2
        if length(vec) == 1
            push!(vec,0)
        end
        vec[1] -= 5
        vec[2] += 1
        cvtbal(vec, str)
    elseif vec[1] < -2
        if length(vec) == 1
            push!(vec,0)
        end
        vec[1] += 5
        vec[2] -= 1
        cvtbal(vec, str)
    else
        cvtbal(vec[2:end], Dict([(2,'2'),(1,'1'),(0,'0'),(-1,'-'),(-2,'=')])[vec[1]] * str )
    end
end

cvt_bob(x) = cvtbal(reverse(cvt5(x)))

filename = ("advent25.test","advent25.input")[2]
answer_1 = cvt_bob(sum([convert_from_res5(line) for line in readlines(filename)]))
println("Answer for part 1: $answer_1")