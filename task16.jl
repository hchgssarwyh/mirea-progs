include("lib_for_robot.jl")
function task16(r)
    x,y = tostart(r)
    side=Ost
    while !isborder(r,Nord)||!isborder(r,Ost)
        movetoside(r,side)
        if !isborder(r,Nord)
            move!(r,Nord)
        end
        side=reverse(side)
    end
    tostart(r)
    todefault(r,Ost,x)
    todefault(r,Nord,y)
end