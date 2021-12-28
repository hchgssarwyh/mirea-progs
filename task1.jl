include("lib_for_robot.jl")
function task1(r)
    for side in (HorizonSide(i) for i=0:3) 
        putmarks(r,side)
        move_marks(r,reverse(side))
    end
    putmarker!(r)
end


