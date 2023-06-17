
lines = readlines("advent8.test")
lines = readlines("advent8.input")

rows = length(lines)
columns = length(lines[1])

visible = zeros(Int,rows,columns)

# across rows first
for row in 1:rows
    visible[row,1]=1
    tallest = lines[row][1]
    for col in 2:columns
        if lines[row][col] > tallest
            visible[row,col] = 1
            tallest = lines[row][col]
        end
    end
    visible[row,columns]=1
    tallest = lines[row][columns]
    for col in columns-1:-1:1
        if lines[row][col] > tallest
            visible[row,col] = 1
            tallest = lines[row][col]
        end
    end
end

# down columns next
for col in 1:columns
    visible[1,col]=1
    tallest = lines[1][col]
    for row in 2:rows
        if lines[row][col] > tallest
            visible[row,col] = 1
            tallest = lines[row][col]
        end
    end
    visible[rows,col]=1
    tallest = lines[rows][col]
    for row in rows-1:-1:1
        if lines[row][col] > tallest
            visible[row,col] = 1
            tallest = lines[row][col]
        end
    end
end

println(sum(visible))

viewscore = zeros(Int,rows,columns)

for row in 2:rows-1
    for col in 2:columns-1
        up = 0
        down = 0
        left = 0
        right = 0
        for r in row+1:rows
            right += 1
            if lines[r][col] >= lines[row][col]
                break
            end
        end
        for r in row-1:-1:1
            left += 1
            if lines[r][col] >= lines[row][col]
                break
            end
        end
        for c in col+1:columns
            down += 1
            if lines[row][c] >= lines[row][col]
                break
            end
        end
        for c in col-1:-1:1
            up += 1
            if lines[row][c] >= lines[row][col]
                break
            end
        end
        viewscore[row,col] = up*down*left*right
    end
end
println(maximum(viewscore))