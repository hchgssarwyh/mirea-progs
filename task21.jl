include("lib_for_robot.jl")
function lab_21(r)
    go_to_west_south_corner_and_return_path!(r; go_around_barriers = true)

    horizontal = 0
    vertical = 0

    border_ver = false
    border_hor = false
    side = Ost

    while !isborder(r, Nord)
        while move_if_possible!(r, side)
            horizontal, border_hor = find_special!(r, horizontal, border_hor, Nord)
            vertical, border_ver = find_special!(r, vertical, border_ver, Ost)
        end

        horizontal, border_hor = find_special!(r, horizontal, border_hor, Nord)
        vertical, border_ver = find_special!(r, vertical, border_ver, Ost)

        side = inverse_side(side)

        move!(r, Nord)
    end

    return horizontal, vertical-5
end