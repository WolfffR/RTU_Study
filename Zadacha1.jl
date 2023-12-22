using HorizonSideRobots
include("moi_functii.jl")
r = Robot("ss/center.sit",animate = true)
function cross!(robot)
    for i in sides
        x = 0
        while !isborder(robot, i)
            putmarker!(robot)
            move!(robot, i)
            x += 1
        end
        putmarker!(robot)
        move!(robot, x, inverse(i))
    end
    
end
function task1!(robot)
    cross!(robot)
    
end
task1!(r)