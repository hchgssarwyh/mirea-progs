include("lib_for_robot.jl")
function task3(r)
    x,y=tostart(r)
    while isborder(r,Ost)==0
        putmarks(r,Nord)
        putmarker!(r)
        move!(r,Ost)
        putmarks(r,Sud)
        putmarker!(r)
    end
    tostart(r)
    for i in 1:x
        move!(r,Ost)
    end
    for i in 1:y
        move!(r,Nord)
    end
end
