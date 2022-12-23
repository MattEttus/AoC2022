
mutable struct Item
    prev
    next
    value::Int
end

chain_length(item) = chain_length(item,item,1)
function chain_length(first,me,count)
    if me.next != first
        chain_length(first,me.next,count+1)
    else
        count
    end
end

print_all(item) = print_all(item,item)
function print_all(first,me)
    println(me.value)
    if me.next != first
        print_all(first,me.next)
    end
end

function process(items::Vector{Item})
    for item in items
        process(item)
    end
end

function process(item::Item)
    sgn = sign(item.value)
    distance = abs(item.value)

    # Need the following b/c we aren't actually moving the item N times, 
    #  so it would get counted again the next time around
    distance = distance % 4999
    if distance == 0
        return
    end
    tmp = item
    for i in 1:distance
        if sgn == 1
            tmp = tmp.next
        else
            tmp = tmp.prev
        end
    end
    # Remove item from current position
    item.prev.next = item.next
    item.next.prev = item.prev
    # Add into new position "after" tmp
    if sgn == -1
        tmp = tmp.prev
    end
    item.next = tmp.next
    item.prev = tmp
    tmp.next = item
    item.next.prev = item
end

function print_result(item)
    tmp = item
    total = 0
    for i in 1:3
        for j in 1:1000
            tmp = tmp.next
        end
        total += tmp.value
    end
    println("Answer for part 1: $total")
end

function create_list(vec)
    items = Vector{Item}()
    myzero = nothing
    
    for (pos, num) in enumerate(vec)
        push!(items,Item(nothing,nothing,num))
        if num == 0
            println("Got a zero at $pos")
            myzero = items[pos]
        end
        if pos > 1
            items[pos-1].next = items[pos]
            items[pos].prev = items[pos-1]
        end
    end
    items[1].prev = items[end]
    items[end].next = items[1]
    return (items,myzero)
end

input = [parse(Int,line) for line in readlines(("advent20.test","advent20.input","advent20.test2")[2])];

(items,myzero) = create_list(input);
print_all(items[1])

process(items)
print_all(items[1])

print_result(myzero)  # answer is 13883

chain_length(items[1])
# 0 works, 8 fails (drops item completely), -8 unchanged, -7 unchanged, 7 unchanged, 9 moves 1 forward, -9 moves 1 backward