using HorizonSideRobots
include("moi_functii")
N = 1
r = Robot("ss/center.sit", animate=true)
function task10!(robot)
    dom = to_corner!(robot::Robot, Sud, West)
    robot = ChessRobotN(robot, N)
    snake!(robot; start_side=Nord, ortogonal_side=Ost)
    to_corner!(robot::AbstractRobot, Sud, West)
    return_home!(robot, dom, Ost, Nord)

end


