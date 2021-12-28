function obojti(r,y)
    tmp=0
    while isborder(r,Nord)
        move!(r,West)
        tmp+=1
    end
    if y>1
        move!(r,Nord)
        move!(r,Nord)
        y-=2
    end
    for i in 1:tmp
        move!(r,Ost)
    end
end
function todefault(r)
    x=0
    y=0
    while isborder(r,Sud)==false || isborder(r,West)==false
        if isborder(r,Sud)==false
            y+=1
            move!(r,Sud)
        end
        if isborder(r,West)==false
            x+=1
            move!(r,West)
        end
    end
    return x,y
end
function tostart(r,y)
    while y>0
        if isborder(r,Nord)==false
            while isborder(r,Nord)==false && y>0
                move!(r,Nord)
                y-=1
            end
        end
        if isborder(r,Nord)==true && y>1
            obojti(r,y)
            y-=2
        end
    end
end

function calc_toboarder(r,side)
    k=0
    while isborder(r,side)==false
        move!(r,side)
        k+=1
    end
    return k
end
function task11(r)
    x,y=todefault(r)
    for i in 1:y
        move!(r,Nord)
    end
    putmarker!(r)
    k=calc_toboarder(r,Nord)
    for i in 1:x
        move!(r,Ost)
    end
    putmarker!(r)
    l=calc_toboarder(r,Ost)
    for i in 1:k
        move!(r,Sud)
    end
    putmarker!(r)
    calc_toboarder(r,Sud)
    for i in 1:l
        move!(r,West)
    end
    putmarker!(r)
    tostart(r,y)
end
    