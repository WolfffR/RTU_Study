using HorizonSideRobots
include("abstract.jl")
HSR = HorizonSideRobots

sides = [Ost, Sud, West, Nord]

mutable struct Chess_Robot{TypeRobot} <: AbstractRobot
    robot::TypeRobot
    need_marker::Bool
end

get_base_robot(robot::Chess_Robot) = robot.robot

function HSR.move!(robot::Chess_Robot, side)
    if robot.need_marker == true
        putmarker!(get_base_robot(robot))
    end
    move!(get_base_robot(robot), side)
    
    robot.need_marker = !robot.need_marker
    if robot.need_marker == true
        putmarker!(get_base_robot(robot))
    end
end

HSR.move!(robot::Chess_Robot,num_steps::Integer, side) =
    for _ in 1:num_steps
        if robot.need_marker == true
            putmarker!(get_base_robot(robot))
        end
        move!(get_base_robot(robot), side)
        robot.need_marker = !robot.need_marker
        if robot.need_marker == true
            putmarker!(get_base_robot(robot))
        end
    end


