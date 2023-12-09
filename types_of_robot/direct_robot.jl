include("../librobot.jl")
include("abstract_direct_robot.jl")

#------- Параметрические типы данных

mutable struct DirectRobot{TypeRobot} <: AbstractDirectRobot
    robot::TypeRobot
    direct::HorizonSide
end

get_baserobot(robot::DirectRobot) = robot.robot
get_direct(robot::DirectRobot) = robot.direct

"""
turn!(robot::DirectRobot, direct::DirectFunction)
-- direct = left | right | inverse
"""
function turn!(robot::DirectRobot, direct::DirectFunction)::Nothing 
    robot.direct = direct(robot.direct)
    return nothing
end

#=
Функции, унаследованные от AbstractDirectRobot <: AbstractRobot:

    move!(robot::DirectRobot, side) 
    isborder(robot::DirectRobot, side)
    putmarker!(robot::DirectRobot)
    ismarker(robot::DirectRobot)
    temperature(robot::DirectRobot)
=#

get_direct(robot::DirectRobot) = robot.direct
get_baserobot(robot::DirectRobot) = robot.robot

along!(direct_robot::DirectRobot) = while try_move!(direct_robot) end

function numsteps_along!(direct_robot::DirectRobot)
    num_steps = 0
    while try_move!(direct_robot) 
        num_steps += 1
    end
    return num_steps
end

along!(stop_condition::Function, direct_robot::DirectRobot)  = 
    while !stop_condition() || try_move!(direct_robot) end

function numsteps_along!(stop_condition::Function, direct_robot::DirectRobot)
    num_steps = 0
    while !stop_condition() || try_move!(direct_robot) 
        num_steps += 1
    end
    return num_steps
end

along!(direct_robot::DirectRobot, num_steps) = for _ in 1:num_steps 
    move!(direct_robot, get_direct(direct_robot)) 
end

try_move!(direct_robot::DirectRobot) = (move!(get_baserobor(direct_robot), get_direct(direct_robot)); true)
