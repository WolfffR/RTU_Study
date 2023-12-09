using HorizonSideRobots
include("abstract")
HSR = HorizonSideRobots

sides = [Ost, Sud, West, Nord]

left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side)-1, 4))
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
#=
abstract type AbstractRobot end
get_base_robot(robot::AbstractRobot) = robot.robot
HSR.move!(robot::AbstractRobot, side) = move!(get_baserobot(robot), side)
HSR.isborder(robot::AbstractRobot, side) = isborder(get_baserobot(robot), side)
HSR.putmarker!(robot::AbstractRobot) = putmarker!(get_baserobot(robot))
HSR.ismarker(robot::AbstractRobot) = ismarker(get_baserobot(robot))
HSR.temperature(robot::AbstractRobot) = temperature(get_baserobot(robot))

# ------------------------------------------------

# include("librobot.jl")
=#
abstract type AbstractDirectRobot <: AbstractRobot end

"""
move!(robot::AbstractDirectRobot) = move!(robot.robot, robot.ort)
-- перемещает робота вперед на 1 клетку
"""
HSR.move!(robot::AbstractDirectRobot) = move!(get_baserobot(robot), get_direct(robot))

DirectFunction = Union{
    typeof(left), 
    typeof(right), 
    typeof(inverse)
}

"""
isborder(robot::AbstractDirectRobot, direct::DirectFunction)::Bool

-- проверяет наличие перегородки с заданной стороны
-- direct = left | right | inverse
"""
HSR.isborder(robot::AbstractDirectRobot, direct::DirectFunction) = isborder(get_baserobot(robot), direct(robot.direct))

HSR.isborder(robot::AbstractDirectRobot) = isborder(robot, get_direct(robot)) 
# - проверяет наличие перегородки прямо по курсу робота

#=
От AbstractRobot унаследованы также функции
    isborder(robot::DirectRobot, side::HorizonSide)
    putmarker!(robot::DirectRobot)
    ismarker(robot::DirectRobot)
    temperature(robot::DirectRobot)
=#

function shuttle!(stop_condition::Function, robot::AbstractDirectRobot)
    num_steps = 0
    while !stop_condition()
        num_steps += 1
        along!(robot, num_steps)
        inverse!(robot)
    end	
end

try_move!(direct_robot::AbstractDirectRobot) = (move!(direct_robot, direct(direct_robot)); true)
