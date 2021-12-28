include("lib_for_robot.jl")
function task18(r::Robot)

    putmarker!(r)

    path = go_to_west_south_corner_and_return_path!(r; go_around_barriers = true)

    for side in (Nord, Ost, Sud, West)
        while isborder(r,side)==false
            move!(r,side)
            putmarker!(r)
        end
    end

    go_by_path!(r, path)
end
