include("lib_for_robot.jl")
function task2(r)
    x,y=tostart(r)
    for s in (Nord,Ost,Sud,West)
        putmarks(r,s)
    end
    for i in 1:x
        move!(r,Ost)
    end
    for i in 1:y
        move!(r,Nord)
    end
end