include("lib_for_robot.jl")
function task10(r)
    side=Ost
    n=0
    k=0
    while isborder(r,Nord)==false
        a,b=moveToSide(r,side)
        k+=a
        n+=b
        move!(r,Nord)
        side=reverse(side)
    end
    a,b=moveToSide(r,side)
    k+=a
    n+=b
    print(k/n)
end