include("lib_for_robot.jl")
function task6(r)
    x,y=tostart(r)
    side=Ost
    bside=Nord
    side = moveandcheck(r,side)
    markerBorder(r,side,bside)
    bside=reverse(side)
    side=Nord
    markerBorder(r,side,bside)
    side=bside
    bside=Sud
    markerBorder(r,side,bside)
    bside=reverse(side)
    side=Sud
    markerBorder(r,side,bside)
    tostart(r)
    while x>0
        if isborder(r,Ost)
            x-=obojti(r,Ost)
        else
            move!(r,Ost)
            x-=1
        end
    end
    while y>0
        if isborder(r,Nord)
            y-=obojti(r,Nord)
        else
            move!(r,Nord)
            y-=1
        end
    end
end