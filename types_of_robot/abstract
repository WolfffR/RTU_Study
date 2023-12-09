using HorizonSideRobots
HSR = HorizonSideRobots

sides = [Ost, Sud, West, Nord]

abstract type AbstractRobot end
get_base_robot(robot::AbstractRobot) = robot.robot
HSR.move!(robot::AbstractRobot, side) = move!(get_base_robot(robot), side)
HSR.isborder(robot::AbstractRobot, side) = isborder(get_base_robot(robot), side)
HSR.putmarker!(robot::AbstractRobot) = putmarker!(get_base_robot(robot))
HSR.ismarker(robot::AbstractRobot) = ismarker(get_base_robot(robot))
HSR.temperature(robot::AbstractRobot) = temperature(get_base_robot(robot))
return_home!(robot::AbstractRobot) = return_home!(get_base_robot(robot))