using HorizonSideRobots
include("moi_functii")
r = Robot("ss/center.sit",animate = true)
function slon_cross!(robot, x_side, y_side)
    shag = 0
    raz = 0
    for i in 1:2
        if i == 2
            raz = shag
            shag = 0
        end
        putmarker!(robot)
        while !isborder(robot, x_side)
            move!(robot, x_side)
            shag += 1
            #println("Шаг сделан - ", shag)
            if isborder(robot, y_side)
                move!(robot, inverse(x_side))
                shag -= 1
                break
            end
            move!(robot, y_side)
            putmarker!(robot)
        end
        putmarker!(robot)
        x_side = inverse(x_side)
        y_side = inverse(y_side)
    end
    return shag- raz
    
end
    
function task4!(robot)
    h_s = slon_cross!(robot, Sud, Ost)
    return_home!(robot,h_s, h_s, Sud, Ost)
    h_s = slon_cross!(robot, Nord, Ost)
    return_home!(robot, h_s, h_s, Nord, Ost)
    
end
task4!(r)