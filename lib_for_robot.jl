function move_marks(r,side)  
    while ismarker(r)==true 
        move!(r,side) 
    end
end
function reverseside(side) 
    side = HorizonSide(mod(Int(side)-1, 4)) 
end
function putmarks(r,side)  
    while isborder(r,side)==false 
        move!(r,side)
        putmarker!(r)
    end
end
function tostart(r)
    x=0
    y=0
    while isborder(r,Sud)==0 || isborder(r,West)==0
        if isborder(r,Sud)==0
            move!(r,Sud)
            y+=1
        end
        if isborder(r,West)==0
            move!(r,West)
            x+=1
        end
    end
        return x,y
end
function go_to_west_south_corner_and_return_path!(r::Robot; go_around_barriers::Bool = false, markers = false)::Array{Tuple{HorizonSide,Int64},1}
    my_ans = []
    a = go_to_border_and_return_path!(r, West; go_around_barriers, markers)
    b = go_to_border_and_return_path!(r, Sud
    ; go_around_barriers, markers)

    for i in a
        push!(my_ans, i)
    end
    for i in b
        push!(my_ans, i)
    end
    return my_ans
end
function go_around_barrier_and_return_path!(r::Robot, direct_side::HorizonSide)::Array{Tuple{HorizonSide,Int64},1}
    my_ans = []
    orthogonal_side = clockwise_side(direct_side)
    reverse_side = inverse_side(orthogonal_side)
    num_of_orthohonal_steps = 0
    num_of_direct_steps = 0

    if !isborder(r, direct_side)

        my_ans = [ (Nord, 0) ]
    else
        while isborder(r,direct_side) == true
            if isborder(r, orthogonal_side) == false
                move!(r, orthogonal_side)
                num_of_orthohonal_steps += 1
            else
                break
            end
        end        

        if isborder(r,direct_side) == false
            move!(r,direct_side)
            num_of_direct_steps += 1
            while isborder(r,reverse_side) == true
                num_of_direct_steps += 1
                move!(r,direct_side)
            end
            push!(my_ans, (inverse_side(orthogonal_side), num_of_orthohonal_steps) )
            push!(my_ans, (inverse_side(direct_side), num_of_direct_steps) )
            push!(my_ans, (inverse_side(reverse_side), num_of_orthohonal_steps) )
        else
            my_ans = [ (Nord, 0) ]
        end

        while num_of_orthohonal_steps > 0
            num_of_orthohonal_steps=num_of_orthohonal_steps-1
            move!(r,reverse_side)
        end

    end
    return my_ans
end
function get_path_length_in_direction(path::Array{Tuple{HorizonSide,Int64},1}, direction::HorizonSide)::Int
    my_ans = 0
    for i in path
        (i[1] == direction || i[1] == inverse_side(direction)) ? my_ans += i[2] : Nothing
    end
    return my_ans
end
function go_to_border_and_return_path!(r::Robot, side::HorizonSide; go_around_barriers::Bool = false, markers = false)::Array{Tuple{HorizonSide,Int64},1}
    my_ans = [ (Nord, 0) ]
    if go_around_barriers
        steps = 0
        if markers
            putmarker!(r)
        end
        if !isborder(r, side)
            move!(r, side)
            steps = 1
            push!(my_ans, (inverse_side(side), 1) )
        else
            path = go_around_barrier_and_return_path!(r, side)
            steps = get_path_length_in_direction(path, side)
            for i in path
                push!(my_ans, i)
            end
        end
        if markers
            putmarker!(r)
        end
        while steps > 0
            if !isborder(r, side)
                move!(r, side)
                steps = 1
                push!(my_ans, (inverse_side(side), 1) )
                if markers
                    putmarker!(r)
                end
            else
                path = go_around_barrier_and_return_path!(r, side)
                steps = get_path_length_in_direction(path, side)
                for i in path
                    push!(my_ans, i)
                end
                if markers
                    putmarker!(r)
                end
            end
        end

    else
        steps=0
        steps_now = go!(r,side; markers)
        while steps_now > 0
            steps += steps_now
            steps_now = go!(r,side; markers)
        end
        push!(my_ans, (inverse_side(side), steps) )
    end
    return my_ans
end
function find_special!(r::Robot, my_ans::Int, border_now::Bool, side::HorizonSide)
    if isborder(r, side)
        border_now = true
    end
    if !isborder(r, side) && border_now
        border_now = false
        my_ans += 1
    end
    return my_ans, border_now
end
function corner_marking(r::Robot)
    robot_path = []
    while (isborder(r, Sud) == false) | (isborder(r, West) == false)
        push!(robot_path, show_path_after_moving(r, West))
        push!(robot_path, show_path_after_moving(r, Sud))
    end
    for side in (Nord, Ost, Sud, West)
        while isborder(r, side) == false
            move!(r, side)
        end
        putmarker!(r)
    end
    back_by_path(r, robot_path)
end
function back_by_path(r::Robot, path::Array)
    k = length(path)
    n = 1 + (k % 2)
    for i in 1:k
        n = n + 1
        side = Nord
        if n % 2 == 1
            side = Ost
        end
        move_n(r, side, path[k - i + 1])
    end
end
function show_path_after_moving(r::Robot, side::HorizonSide)
    n = 0
    while isborder(r, side)==false
        move!(r, side)
        n = n + 1
    end 
    return n
end
function clockwise_side(side)
    return HorizonSide(mod(Int(side)-1,4))
end
function inverse_side(side)
    return HorizonSide(mod(Int(side)+2, 4))
end
function special_move!(r,side,num)
    for _ in 1:num
        if ismarker(r)
            return nothing
        end
        isborder(r, side) ? go_around(r, side) : move!(r,side)
    end
end
function counterclockwise_side(side)
    return HorizonSide(mod(Int(side)+1,4))
end
function go_around(r, direct_side)
    move_side = clockwise_side(direct_side)
    left_moves = 0
    right_moves = 0
    while isborder(r, direct_side)
        left_moves += 1
        right_moves = left_moves
        while isborder(r,direct_side) && right_moves > 0
            right_moves -= 1
            move!(r,move_side)
        end
        side=inverse_side(move_side)
    end
    move!(r,direct_side)
    left_moves /= 2
    while left_moves > 0
        left_moves -= 1
        move!(r,move_side)
    end
end
function direction_mark(r::Robot, side::HorizonSide, n::Int, all::Int)
    k = 0
    p = 0
    while isborder(r, side) == false
        p = 0
        for i in 1:n
            if isborder(r, side) == false
                putmarker!(r)
                move!(r, side)
                k = k + 1
                p += 1
            end
        end
        if (isborder(r, side) == true) && (p != n)
            putmarker!(r)
        end
        for j in 1:n
            if isborder(r, side) == false
                move!(r, side)
                k += 1
            end
        end
    end
    l = 2n + 1
    while all >= l
        if all == l
            move!(r, HorizonSide(mod(Int(side) + 2, 4)))
            if ismarker(r) == false
                move!(r, side)
                putmarker!(r)
            end
        end
        l= l + 3n
    end
    return k
end
function move_n(r::Robot, side::HorizonSide, n::Int)
    for i in 1:n
        move!(r, side)
    end
end
function go_to_bottom_left_corner_return_coords_shift_of_start(r::Robot)
    x=0
    y=0
    while isborder(r, West) == false
        move!(r, West)
        x = x + 1
    end
    while isborder(r, Sud) == false
        move!(r, Sud)
        y = y + 1
    end
    return x, y
end
function show_path_after_moving(r::Robot, side::HorizonSide)
    n = 0
    while isborder(r, side) == false
        move!(r, side)
        n = n + 1
    end 
    return n
end
function moveandcheck(r,side)
    fl=true
    while isborder(r,side)==false
        if isborder(r,Nord)==false
            move!(r,side)
        else
            fl=false
            break
        end
    end
    if fl
        move!(r,Nord)
        return moveandcheck(r,reverse(side))
    end
    return side
end
function reverse(side) 
    side = HorizonSide(mod(Int(side)+2, 4)) 
end
function markerBorder(r,side,bside)
    while isborder(r,bside)==true
        putmarker!(r)
        move!(r,side)
    end
    putmarker!(r)
    move!(r,bside)
end
function obojti(r::Robot,side::HorizonSide)
    """Обходит прямоугольные препятствия в направлении side,
     возвращает на сколько изменилась координата робота по оси, соответсвующей side"""
    tmp=0
    m=0
    nside=reverseside(side)
    kside=reverseside(reverseside(nside))
    while isborder(r,side)==true && isborder(r,nside)==false
        move!(r,nside)
        tmp+=1
    end
    if isborder(r,side)==true && isborder(r,nside)==true
        for i in 1:tmp
            move!(r,kside)
        end
    else
        move!(r,side)
        m+=1
        while isborder(r,kside)==true
            move!(r,side)
            m+=1
        end
        for i in 1:tmp
            move!(r,kside)
        end
    end
    return m
end
function movetonord(r,x,y)
    while isborder(r,Nord)==0
        if ((x+y)%2==0)
            putmarker!(r)
        end
        move!(r,Nord)
        y+=1
        if ((x+y)%2==0)
            putmarker!(r)
        end
    end
    return y
end
function movetosud(r,x,y)
    while isborder(r,Sud)==0
        if ((x+y)%2==0)
            putmarker!(r)
        end
        move!(r,Sud)
        y+=1
    end
    return y
end
function moveToSide(r,side)
    k=0
    n=0
    while isborder(r,side)==false
        if ismarker(r)==true
            k+=temperature(r)
            n+=1
        end
        move!(r,side)
    end
    return k,n
end
function move_diog(r,side)
    x=0
    y=0
    while isborder(r,side[1])==false && isborder(r,side[2])==false
        move!(r,side[1])
        move!(r,side[2])
        x+=1
        y+=1
        putmarker!(r)
    end
    return x,y
end
function rtn_diog(r,side,x,y)
    side=(reverse(side[1]),reverse(side[2]))
    for i in 1:x
        move!(r,side[1])
    end
    for i in 1:y
        move!(r,side[2])
    end
end
function todefault(r,side,x)
    while (isborder(r,side)==false)&&x>0
        move!(r,side)
        x-=1
    end
    if x>0
        t=obojti(r,side)
        if t!=0
            x-=t
            todefault(r,side,x)
        else
            return x
        end
    end
end
function movetoside(r,side)
    x=0
    while isborder(r,side)==false
        putmarker!(r)
        move!(r,side)
        x+=1
    end
    putmarker!(r)
    t=obojti(r,side)
    if t!=0
        x+=t
        x+=movetoside(r,side)
    else
        return x
    end
end
function rtn(r,side,x)
    while x>1&&isborder(r,side)==false
        move!(r,side)
        x-=1
    end
    t=obojti(r,side)
    if t!=0&&x>1
        x-=t
        x-=rtn(r,side,x)
    else
        print(x)
        return x
    end
end
function go_to_border_come_back_and_return_distance!(r::Robot, side::HorizonSide; go_around_barriers::Bool = false, markers = false)::Int
    my_ans = 0
    if go_around_barriers
        # здесь и далее интерпритатор понимает, что я хочу записать в именованный параметр markers вызываемой функции значение из параметра markers текущей функции
        if markers
            putmarker!(r)
        end
        if !isborder(r, side)
            move!(r, side)
            steps = 1
        else
            steps = get_path_length_in_direction(go_around_barrier_and_return_path!(r, side), side)
        end
        my_ans += steps
        if markers
            putmarker!(r)
        end
        while steps > 0
            if !isborder(r, side)
                move!(r, side)
                steps = 1
            else
                steps = get_path_length_in_direction(go_around_barrier_and_return_path!(r, side), side)
            end
            my_ans += steps
        end
        if markers
            putmarker!(r)
        end
        go!(r, inverse_side(side); steps = my_ans, go_around_barriers = true)
    else
        while go!(r, side; markers) > 0
            my_ans += 1
        end
        go!(r, inverse_side(side); steps = my_ans)
    end
    return my_ans
end
function go!(r::Robot, side::HorizonSide; steps::Int = 1, go_around_barriers::Bool = false, markers = false)::Int
    my_ans = 0
    if markers
        putmarker!(r)
    end
    if (go_around_barriers)
        path = around_move_return_path!(r, side; steps, markers)
        my_ans = get_path_length_in_direction(path, side)
    else
        for i ∈ 1:steps

            if (markers)
                putmarker!(r)
            end

            if !isborder(r, side)
                move!(r, side)
                my_ans += 1
            else
                for i ∈ 1:my_ans
                    move!(r, inverse_side(side))
                end
                my_ans = 0
                break
            end
        end
        if (markers)
            putmarker!(r)
        end
    end

    return my_ans
end
function around_move_return_path!(r::Robot, side::HorizonSide; steps::Int = 1, markers = false)::Array{Tuple{HorizonSide,Int64},1}
    path = [ (Nord, 0) ] 
    steps_to_do = steps
    
    while steps_to_do > 0

        if markers
            putmarker!(r)
        end

        path_now = go_around_barrier_and_return_path!(r, side)

        for i in path_now
            push!(path, i)
        end

        steps_to_do -= get_path_length_in_direction(path_now, side)

        if !isborder(r, side) && steps_to_do > 0
            push!(path, ( inverse_side(side), 1))
            move!(r, side)
            steps_to_do -= 1

            if markers
                putmarker!(r)
            end
        elseif get_path_length_in_direction(path_now, side) == 0
            steps_to_do = -1
            break
        end
        if markers && steps_to_do >= 0
            putmarker!(r)
        end
    end
    if steps_to_do < 0 
        my_ans = 0
        # возвращаемся назад
        go_by_path!(r, path)
        path = [ (North, 0) ]
    end

    return path
end
function go_by_path!(r::Robot, path::Array{Tuple{HorizonSide,Int64},1})
    new_path = reverse(path)
    for i in new_path
        go!(r, i[1]; steps = i[2])
    end
end
function find_special!(r::Robot, my_ans::Int, border_now::Bool, side::HorizonSide)
    if isborder(r, side)
        border_now = true
    end
    if !isborder(r, side) && border_now
        border_now = false
        my_ans += 1
    end
    return my_ans, border_now
end

function move_if_possible!(r::Robot, direct_side::HorizonSide)::Bool
    orthogonal_side = counterclockwise_side(direct_side)
    reverse_side = inverse_side(orthogonal_side)
    num_steps=0
    if isborder(r,direct_side)==false
        move!(r,direct_side)
        result=true
    else
        while isborder(r,direct_side) == true
            if isborder(r, orthogonal_side) == false
                move!(r, orthogonal_side)
                num_steps += 1
            else
                break
            end
        end
        if isborder(r,direct_side) == false
            move!(r,direct_side)
            while isborder(r,reverse_side) == true
                move!(r,direct_side)
            end
            result = true
        else
            result = false
        end
        while num_steps>0
            num_steps=num_steps-1
            move!(r,reverse_side)
        end
    end
    return result
end