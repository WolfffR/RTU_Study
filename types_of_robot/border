using HorizonSideRobots
include("abstract")
HSR = HorizonSideRobots

sides = [Ost, Sud, West, Nord]

struct BorderRobot{TypeRobot} <: AbstractRobot
    robot::TypeRobot
end

get_baserobot(robot::BorderRobot)::Robot = get_baserobot(robot.robot) 
# !!! здесь предполагается, что get_baserobot(robot.robot) вернет значение типа Rобот - это нужно для того, чтобы try_move! ТОЛЬКО перемещела робота 
get_baserobot(robot::Robot) = robot

function HSR.move!(stop_condition::Function, robot::AbstractRobot, side; num_maxsteps::Integer)
    n = 0
    while n < num_maxsteps && stop_condition() == false
        n += 1
        move!(robot, side)
    end
    return n
end

HSR.move!(robot::AbstractRobot,num_steps::Integer, side) =
    for _ ∈ 1:num_steps
        move!(robot, side)
    end

function try_move!(robot::BorderRobot, side)
    ortogonal_side = left(side)
    back_side = inverse(ortogonal_side)
    n=0
    while isborder(robot, side)==true && isborder(robot, ortogonal_side) == false
        move!(robot, ortogonal_side)
        n += 1
    end
    if isborder(robot,side)==true
        move!(robot, back_side, n)
        return false
    end
    move!(robot, side)
    if n > 0 # продолжается обход
        along!(()->!isborder(robot, back_side), robot, side) 
        move!(robot, back_side, n)
    end
    return true
end


#move!(robot::BorderRobot, side) = (try_move!(robot::BorderRobot, side); nothing)

along!(robot::BorderRobot, side::HorizonSide) = while try_move!(robot, side) end

along!(stop_condition::Function, robot::BorderRobot, side::HorizonSide) =
    while !stop_condition() && try_move!(robot, side) end

#-------

function return_home!(r::BorderRobot{T}) where T
    # Дополнительные действия для BorderRobot, если это необходимо
    println("Return home for BorderRobot with type $T")
end


