include("lib_for_robot.jl")
function task19(r)
    steps = 1
    side = Nord
    while ismarker(r)==false
        for _ in 1:2
            special_move!(r,side,steps)
            side=counterclockwise_side(side)
        end
        steps += 1
    end
    println("Marker found!")
end
