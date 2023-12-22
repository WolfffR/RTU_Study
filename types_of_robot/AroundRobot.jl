using HorizonSideRobots
include("../types_of_robot/abstract.jl")
include("../types_of_robot/edge_robot.jl")
@enum Оrientation Positive=0 Negative=1


mutable struct AroundRobot{TypeRobot}
    edge_robot::EdgeRobot{TypeRobot}
    coord_robot::TypeRobot # - нужно, чтобы иметь доступ ккоординатам
    start_coords::NTuple{2,Int}# - стартовые кординаты робота
    start_direct::HorizonSide # - стартовое направление робота
    function AroundRobot{TypeRobot}(robot::TypeRobot) where {TypeRobot}
        type_robot = TypeRobot(robot)
        new(
            EdgeRobot{TypeRobot}(type_robot),Type_robot,
            get_coords(type_robot),
            get_direct(robot.edge_robot)
        )
    end
end

get_coords(robot::AroundRobot)= get_coords(robot.type_robot)
get_direct(robot::AroundRobot)=get_direct(robot.edge_robot)
is_start(robot::AroundRobot) = (get_coords(robot) == robot.start_coord ) && (get_direct(robot) == robot.start_direct)

"""
move!(robot::AroundRobot)
-- перемещает робота вдоль границы в установленном
направлении, и разворачивает робота так,
чтобы он беспрепятственно мог бы сделать следующий шаг вдоль
границы; при этом отслеживаются координаты текущего
положения робота
"""
HorizonSideRobots.move!(robot::AroundRobot) = move!(robot.robot)

# """
# around!(robot::AroundRobot,direct::Orientation=Positive)::Nothing
# -- осуществляет обход роботом границы в положительном
# направлении вплоть до момента возвращения робота в исходное
# положение
# """
function around!(robot::AroundRobot,direct)
    move!(robot, direct)
    while !is_start(robot)
        move!(robot, direct)
    end
end

abstract type AbstractCoordsRobot <: AbstractRobot end

function HSR.move!(robot::AbstractCoordsRobot,side::HorizonSide)
    move!(get_base_robot(robot))
    x, y = get_coords(robot)
    if side==Nord
        set_coords(robot, x, y+1)
    elseif side==Sud
        set_coords(robot, x, y-1)
    elseif side==Ost
        set_coords(robot, x+1, y)
    else #if side==West
        set_coords(robot,x-1, y)
    end
end
r = 
along!(r, Positive)