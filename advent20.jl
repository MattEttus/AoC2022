
mutable struct Item
    prev
    next
    value::Int
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
    if item.value % 5000 == 0
        return
    end
    sgn = sign(item.value)
    tmp = item
    for i in 1:abs(item.value)
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

input = [parse(Int,line) for line in readlines(("advent20.test","advent20.input","advent20.test2")[3])]

(items,myzero) = create_list(input);
print_all(items[1])
# process(items)

process(items[8]);
print_all(items[1])

print_result(myzero)

# 8 fails, -8 works