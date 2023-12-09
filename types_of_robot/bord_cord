using HorizonSideRobots
include("coordinates")
mutable struct Border_Coord_Robot <: AbstractRobot
    robot :: Robot
    coords :: Coordinates
    Border_Coord_Robot(robot :: Robot ) = new(robot,Coordinates(0,0))
    Border_Coord_Robot(robot :: Robot , x, y ) = new(robot,Coordinates(x,y))
end

get_base_robot(robot::Border_Coord_Robot) = robot.robot

function HorizonSideRobots.move!(r :: Border_Coord_Robot, side :: HorizonSide)
    xy = get(r.coords)
    if abs(xy[1]) == abs(xy[2])
        putmarker!(r)
        
    end
    move!(get_base_robot(r),side)
    move!(r.coords, side)

end

function try_move!(robot::Border_Coord_Robot, side)
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
along!(robot::Border_Coord_Robot, side::HorizonSide) = while try_move!(robot, side) end