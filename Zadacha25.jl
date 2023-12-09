using HorizonSideRobots
include("moi_functii")
condition = false
r = Chess_Robot(Robot("ss/center.sit",animate = true),condition)

function task25!(robot,side)

    if !isborder(robot,side)
        move!(robot,side)
        task25!(robot,side)
    end
end
