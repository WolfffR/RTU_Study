using HorizonSideRobots
include("moi_functii")
r = Robot(animate = true)
function paint_along!(robot, side::HorizonSide)
    while !isborder(robot, side)
        putmarker!(r)
        move!(robot, side)
        putmarker!(r)

    end 
    return 1
end
function paint_the_town_red!(robot)
    direction = Nord
    while !isborder(robot, Ost) || !isborder(robot,direction)
        paint_along!(robot, direction)
        
        if isborder(robot, Ost)
            break
        end
        move!(robot, Ost)
        direction = inverse(direction)
    end
end  
function return_home(robot,x,y)
    for i in 1:x
        move!(robot,Ost)
    end
    for h in 1:y
        move!(robot,Nord)
    end
    
end
function task3!(robot)
    y = go_along_shag!(robot, Sud)
    x = go_along_shag!(robot, West)
    paint_the_town_red!(robot)
    to_corner!(robot, West, Sud)
    return_home!(robot, x, y, Ost, Nord)
end
task3!(r)