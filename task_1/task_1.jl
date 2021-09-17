function putmarks(r,side)  
    while isborder(r,side)==false 
        move!(r,side)
        putmarker!(r)
    end
end

function move_marks(r,side)  
    while ismarker(r)==true 
        move!(r,side) 
    end
end
function reverse(side) 
     side = HorizonSide(mod(Int(side)+2, 4)) 
end

function kross(r)
    for side in (HorizonSide(i) for i=0:3) 
        putmarks(r,side)
        move_marks(r,reverse(side))
    end
    putmarker!(r)
end


