using HorizonSideRobots
include("moi_functii.jl")
r = EdgeRobot(Malyar_Robot(Robot("ss/pereprava26.sit",animate = true)))
function task26!(robot)
    dom = move_to_angle!(robot)
    snake_border!(robot; start_side=Nord, ortogonal_side=Ost)
    move_to_angle!(robot)
    move!(robot, dom)

    
end
task26!(r)