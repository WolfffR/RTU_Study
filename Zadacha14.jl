using HorizonSideRobots
include("moi_functii")
r = BorderRobot(Chess_Robot(Robot("ss/pereprava14.sit",animate = true), true))

function snake_border!(robot; start_side, ortogonal_side)
    s = start_side
    along!(robot, s) do
        isborder(robot, s)
    end
    while try_move!(robot, ortogonal_side)
        s = inverse(s)
        along!(robot, s)
    end
end
function task14!(robot)
    back_path = move_to_angle!(robot)
    snake_border!(robot; start_side = Ost, ortogonal_side = Nord)
    to_corner!(robot, Sud, West)
    move!(robot, back_path)
end
task14!(r)
#task14!(r)