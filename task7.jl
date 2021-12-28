include("lib_for_robot.jl")
function task7(r::Robot)
    x=0
    y=0
    x,y=tostart(r)
    while isborder(r,Ost)==0
        movetonord(r,x,y)
        move!(r,Ost)
        x+=1
        movetosud(r,x,y)
    end
    if ((x+y)%2==0)
        putmarker!(r)
    end
end