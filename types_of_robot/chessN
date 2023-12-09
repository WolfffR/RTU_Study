using HorizonSideRobots
include("abstract")
mutable struct Coordinates

    x::Int
    y::Int

end

function HorizonSideRobots.move!(coord::Coordinates, side::HorizonSide)
    if side == Ost
        coord.x += 1
    elseif side == West
        coord.x -= 1
    elseif side == Nord
        coord.y += 1
    else # side == Sud
        coord.y -= 1
    end
    nothing
end

get(coord::Coordinates) = (coord.x, coord.y)

struct ChessRobotN <: AbstractRobot

    robot::Robot
    coordinates::Coordinates
    N::Int
    ChessRobotN(r, N) = new(r, Coordinates(0, 0), N)

end

get_baserobot(robot::ChessRobotN) = robot.robot

function HorizonSideRobots.move!(robot::ChessRobotN, side)

    x, y = get(robot.coordinates) .÷ N
    display((x, y))
    if isodd(x) && isodd(y) || iseven(x) && iseven(y)
        putmarker!(robot)
    end

    move!(robot.robot, side)
    move!(robot.coordinates, side) 
    


end
# function HorizonSideRobots.move!(robot::ChessRobotN, side; d::Bool)

#     x, y = get(robot.coordinates) .÷ N
#     display((x, y))
#     if isodd(x) && isodd(y) || iseven(x) && iseven(y)
#         putmarker!(robot)
#     end

#     move!(robot.robot, side)
#     if d == false
#         move!(robot.coordinates, side)
#     end


# end
