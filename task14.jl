include("lib_for_robot.jl")
function task14(r)
    for i in 0:3
        x=movetoside(r,HorizonSide(i))
        rtn(r,reverse(HorizonSide(i)),x)
    end
end