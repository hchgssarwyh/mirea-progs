include("lib_for_robot.jl")
function task15(r)
    x,y=tostart(r)
    side=Nord
    for i in 0:3
        while isborder(r,side)==false
            putmarker!(r)
            move!(r,side)
        end
        side=reverseside(side)
    end
    todefault(r,Ost,x)
    todefault(r,Nord,y)
    
end