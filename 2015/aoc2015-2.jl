
total = 0
ribbon = 0

for line in readlines("input2015-2.txt")
    l, w, h = parse.(Int,split(line,'x'))
    total += 2 * (l*w + l*h + w*h)
    total += reduce(*,sort([l,w,h])[1:2])
    ribbon += 2 * sum(sort([l,w,h])[1:2]) + l*w*h
end
println(total)
println(ribbon)