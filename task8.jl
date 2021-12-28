include("lib_for_robot.jl")
function task8(r)
    i=0
    side=West
    while isborder(r,Nord)==true
        for tmp in 0:i
            move!(r,side)
        end
        side=reverse(side)
        i+=1
    end
end