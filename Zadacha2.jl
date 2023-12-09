using HorizonSideRobots
include("moi_functii")
using HorizonSideRobots
sides = [Ost, Sud, West, Nord]
r = Robot("ss/center.sit",animate = true)
function to_border!(robot)
    along!(robot, Nord)
end
function perimetr!(robot)
    for s in sides
        while !isborder(robot, s)
            putmarker!(robot)
            move!(robot, s)
        end
    end

end

function task2!(robot)
    y = go_along_shag!(robot, Nord)
    x = go_along_shag!(robot, West)
    to_border!(robot)
    perimetr!(robot)
  #  println(y)
   # println(x)
    return_home!(robot, x, y, Ost, Sud)
end
task2!(r)