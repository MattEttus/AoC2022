using DataStructures

mutable struct DIR
    name::String
    subdirs::Dict{String,DIR}
    files::Int     # Just track total size of files
end

DIR(name::String) = DIR(name,Dict{String,DIR}(),0)

stk = Stack{DIR}()
root = DIR("/")

open("advent7.input") do f
    line = split(readline(f),' ', keepempty=false)   # consume first line which gets us to root directory
    println(line)
    line = split(readline(f),' ', keepempty=false)
    pwd = root

    while true
        println(line)
        if line[1] == "\$"
            if line[2] == "cd"
                if line[3] == ".."
                    pwd = pop!(stk)
                else
                    push!(stk,pwd)
                    pwd = pwd.subdirs[line[3]]
                end
                if eof(f)
                    break
                end
                line = split(readline(f),' ', keepempty=false)
            elseif line[2] == "ls"
                pwd.files = 0
                while !eof(f)
                    line = split(readline(f),' ', keepempty=false)
                    if line[1] == "\$"
                        break
                    elseif line[1] == "dir"
                        pwd.subdirs[line[2]] = DIR(String(line[2]))
                    else  # files
                        pwd.files += parse(Int,line[1])  # ignore filename
                    end
                end
                if eof(f)
                    break
                end
            else
                println(line)
                throw("Unexpected command")
            end
        else
            println("HERE", line)
            throw("Expected a command, got something else")
        end
    end
end


function total_size(dir::DIR, list_short, list_all)
    total = dir.files
    for d in values(dir.subdirs)
        total += total_size(d, list_short, list_all)
    end
    push!(list_all,total)
    if total <= 100000
        push!(list_short,total)
    end
    return total
end


shortlist = []
all_list = []
space_needed = 30000000
space_have = 70000000 - total_size(root,shortlist,all_list)
to_remove = space_needed - space_have
sum(shortlist)

remove_this = sort(all_list[all_list .> to_remove])[1]