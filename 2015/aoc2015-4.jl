
using MD5


input = "abcdef"
num = 609000

input = "yzbqklnj"
num = 0

while bytes2hex(md5(input * string(num)))[1:5] != "00000"
    num += 1
end

while bytes2hex(md5(input * string(num)))[1:6] != "000000"
    num += 1
end
println(num)