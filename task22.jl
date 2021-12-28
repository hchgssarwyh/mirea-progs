function lab_22(r)
    go_to_west_south_corner_and_return_path!(r; go_around_barriers = true)

    my_ans = 0
    border_now = false
    side = Ost
    while !isborder(r, Nord)
        while move_if_possible!(r, side)
            (my_ans, border_now) = find_special!(r, my_ans, border_now, side)
        end

        my_ans, border_now = find_special!(r, my_ans, border_now, side)

        side = inverse_side(side)
        move!(r, Nord)

        my_ans, border_now = find_special!(r, my_ans, border_now, side)
    end

    return my_ans
end

function find_special!(r::Robot, my_ans::Int, border_now::Bool, move_side::HorizonSide)
    if isborder(r, Nord)
        border_now = true
    end
    if !isborder(r, Nord) && border_now
        border_now = false
       
        move!(r, Nord)
        if isborder(r, inverse_side(move_side))
            my_ans += 1
        end
        move!(r, Ost)

    end
    return my_ans, border_now
end
