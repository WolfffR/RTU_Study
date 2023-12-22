using HorizonSideRobots
include("moi_functii.jl")
r = Robot("ss/pusto.sit", animate = true)

function fast_move_marker!(stop_condition::Function, robot, b, side)

    for i in 1:b

        if !stop_condition()
            move!(robot,side)
        else break
        end

    end

end
function task8!(robot)
    start_p = West
    stop_condition = ()->ismarker(robot)
    # spiral!(()->ismarker(robot), robot; start_p = West, rotation = right)
    b=1
    a = start_p
    while ismarker(robot) == false
        fast_move_marker!(stop_condition, robot, b, a)
        a = right(a)
        if a == start_p || a == inverse(start_p)
            b+=1
        end
    end



end