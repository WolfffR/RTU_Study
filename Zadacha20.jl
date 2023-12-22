using HorizonSideRobots
include("moi_functii.jl")
r = Robot(animate = true)
function re_marker_touch!(robot, side)
    if isborder(robot, side)
        putmarker!(robot)
    else
        move!(robot, side)
        re_marker_touch!(robot, side)
        move!(robot, inverse(side))
    end
    

    
end
task20!(robot, side) = re_marker_touch!(robot, side)