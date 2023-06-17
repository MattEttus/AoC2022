
inp = "bvwbjplbgvbhsrlpgdmjqwftvncz"  # 5
inp = "nppdvjthqldpwncqszvftbrmjlhg"  # 6
inp = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"  # 10
inp = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"  # 11

inp = readline("advent6.input")

function alldiff(str)
    for i in 1:length(str)-1
        for j in i+1:length(str)    
            if str[i] == str[j]
                return false
            end
        end
    end
    return true
end

n=14
for i in 1:length(inp)-n+1
    if alldiff(inp[i:i+n-1])
        println(i+n-1)
        break
    end
end

for i in 4:length(inp)
    if inp[i] != inp[i-1] != inp[i-2] != inp[i-3] != inp[i-1] 
        if inp[i-2] != inp[i] != inp[i-3]
            println(i)
            break
        end
    end
end