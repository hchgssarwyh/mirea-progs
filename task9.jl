include("lib_for_robot.jl")
function task9(r)
    i=0
    side=West
    fl=true
    while fl
        for tmp in 0:i
            move!(r,side)
            if ismarker(r)==true
                fl=false
                break
            end
        end
        side=reverseside(side)
        if fl
            for tmp in 0:i
                move!(r,side)
                if ismarker(r)==true
                    fl=false
                    break
                end
            end
        end
        side=reverseside(side)
        i+=1
    end
end