include("lib_for_robot.jl")
function task4(r)
    x,y=tostart(r)
    i=0
    k=0
    while isborder(r,Ost)==0
        move!(r,Ost)
        k+=1
    end
    tostart(r)
    while isborder(r,Nord)==0
        for p in 1:(k-i)
            putmarker!(r)
            move!(r,Ost)
        end
        putmarker!(r)
        move!(r,Nord)
        for p in 1:(k-i)
            move!(r,West)
        end
        i+=1
    end
    for p in 0:(k-i)
        putmarker!(r)
        move!(r,Ost)
    end
    tostart(r)
    for i in 1:x
        move!(r,Ost)
    end
    for i in 1:y
        move!(r,Nord)
    end
end