using HorizonSideRobots
include("moi_functii.jl")
r = Robot("ss/pusto.sit", animate = true)
function task17!(robot)
    spiral!(()->ismarker(robot), robot; start_p = West, rotation = right)
end
#task17!(r)