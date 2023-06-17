

scoring = Dict( "A X" => 4,   # Tie (3) + 1
                "A Y" => 8,   # Win (6) + 2
                "A Z" => 3,   # Lose (0) + 3

                "B X" => 1,   # Lose (0) + 1
                "B Y" => 5,   # Tie (3) + 2
                "B Z" => 9,   # Win (6) + 3

                "C X" => 7,   # Win (6) + 1
                "C Y" => 2,   # Lose (0) + 2
                "C Z" => 6   # Tie (3) + 3
                )


scoring2 = Dict("A X" => 3,   # Lose (0) + 3
                "A Y" => 4,   # Tie (3) + 1
                "A Z" => 8,   # Win (6) + 2

                "B X" => 1,   # Lose (0) + 1
                "B Y" => 5,   # Tie (3) + 2
                "B Z" => 9,   # Win (6) + 3

                "C X" => 2,   # Lose (0) + 2
                "C Y" => 6,   # Tie (3) + 3
                "C Z" => 7   # Win (6) + 1
                )

lines = readlines("advent-2.input")

total = 0
for line in lines
    total += scoring2[line]
end

println("Score is ", total)
