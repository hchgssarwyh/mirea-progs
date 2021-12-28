include("lib_for_robot.jl")
function task5(r::Robot)
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
