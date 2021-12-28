include("lib_for_robot.jl")
function task12(r::Robot,n::Int)
    x, y = go_to_bottom_left_corner_return_coords_shift_of_start(r)
    
    all = show_path_after_moving(r, Nord)+1
    while isborder(r, Sud) == false
        move!(r, Sud)
    end

    side=Nord
    t=0
    while isborder(r, Ost) == false
        if n <= t < 2n
            for i in 1:n
                move!(r,side)
            end
        end

        direction_mark(r,side,n,all)

        t = t + 1
        if t > 2n
            t -= 2n
        end

        move!(r, Ost)
        side = HorizonSide(mod(Int(side) + 2, 4))
        show_path_after_moving(r, side)
        side = HorizonSide(mod(Int(side) + 2, 4))
    end
    if n <= t < 2n
        for i in 1:n
            move!(r, side)
        end
    end
    direction_mark(r, side, n, all)

    go_to_bottom_left_corner_return_coords_shift_of_start(r)
    move_n(r, Ost, x)
    move_n(r, Nord, y)
end