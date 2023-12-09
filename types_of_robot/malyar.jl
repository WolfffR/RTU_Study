using HorizonSideRobots
HSR = HorizonSideRobots


mutable struct Malyar_Robot{TypeRobot} <: AbstractRobot
    robot::TypeRobot

end

get_base_robot(robot::Malyar_Robot) = robot.robot

function HSR.move!(robot::Malyar_Robot, side)
    putmarker!(get_base_robot(robot))
    move!(get_base_robot(robot), side)
    putmarker!(get_base_robot(robot))
end