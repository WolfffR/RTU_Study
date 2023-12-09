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

#abstract type Coord <: AbstractRobot end

#get_coords(robot :: Coord) = get_coords( get_base_robot( robot ))
"""
Эта функция представляет собой простую 
реализацию механизма switch/case для 
вызова функции f с аргументами x...
"""
switch(f :: Function, x...) = f(x...) 

mutable struct CoordRobot <: AbstractRobot
    robot :: Union{AbstractRobot, Robot}
    #coords:: Coordinates
    
    x :: Int
    y :: Int
    CoordRobot(robot :: Union{AbstractRobot,Robot} ) = new(robot,0,0)
    CoordRobot(robot :: Union{AbstractRobot,Robot} , x, y ) = new(robot,x,y)
end
get_base_robot(robot::CoordRobot) = robot.robot

function HorizonSideRobots.move!(r :: CoordRobot, side :: HorizonSide)
    switch(side) do side
        side==Nord && (r.y+=1)
        side==Sud && (r.y-=1)
        side==West && (r.x+=1)
        side==Ost && (r.x-=1)
    end
    move!(get_base_robot(r),side)
end
### СПРОСИТЬ И ИСПРАВИТЬ
function return_home!(r::CoordRobot)

    #r=XBorderRobot(r)
    side_x, side_y = nothing, nothing
    if r.x >= 0 
        side_x = West
    end
    if r.x < 0 
        side_x = Ost
    end
    if r.y >= 0
        side_y = Sud
    end
    if r.y < 0
    side_y = Nord
    end
    try_move!(r, side_x, abs(r.x))
    try_move!(r, side_y, abs(r.y))

end

get_coords( robot :: CoordRobot ) = (robot.x,robot.y)