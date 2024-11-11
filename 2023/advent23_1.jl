files = ["advent23_1.test","advent23_1.input","advent23_1.test2",]

sum = 0
for line in readlines(files[2])
    digits = [x for x in line if x ∈ '0':'9']
    sum += parse(Int,digits[1] * digits[end])
end
sum


words = ["one","two","three","four","five","six","seven","eight","nine"]
numerals = '0':'9'

sum = 0
for line in readlines(files[2])
    digits = []
    for i in eachindex(line)
        if line[i] ∈ numerals
            push!(digits,parse(Int,line[i]))
        else
            for (num, word) in enumerate(words)
                if i + length(word) - 1 <= length(line)
                    if word == line[i:(i+length(word)-1)]
                        push!(digits,num)
                    end
                end
            end
        end
    end
    sum += 10*digits[1] + digits[end]
end
println(sum)