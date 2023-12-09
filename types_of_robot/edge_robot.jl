include("direct_robot.jl")

@enum Оrientation Positive=0 Negative=1

inverse(orientation::Оrientation) = Оrientation(mod(Int(orientation)+1, 2))

#--------------------------------------------------
"""
EdgeRobot{TypeRobot}(robot::TypeRobot, edge_side::HorizonSide, orientation::Orientation=Positive) where TypeRobot

-- робот, перемещающийся по границе, в положительном или отрицательном направлениях
-- edge_side - сторона горизонта, с которой от робота находится граница, и относительно которой он должен быть развернут,
и быть готовым к выполнению шага вперед 
"""
mutable struct EdgeRobot{TypeRobot} <: AbstractDirectRobot
    direct_robot::DirectRobot{TypeRobot}
    orientation::Оrientation

    function EdgeRobot{TypeRobot}(robot::TypeRobot, edge_start_side::HorizonSide, orientation::Оrientation=Positive) where TypeRobot
        # Робота надо развернуть в соответствии с заданным направлением обхода границы (orientation),  
        # так, чтобы он мог сделать шаг вперед вдоль границы
        if orientation == Positive
            rot_fun = left
            inv_rot_fun = right
        else # orientation == Negative
            inv_rot_fun = left   
            rot_fun = right
        end
        direct_side = edge_start_side # Nord
   	    direct_robot = DirectRobot{TypeRobot}(robot, direct_side)
        n=0
        while !isborder(direct_robot) && n < 4
            turn!(direct_robot, rot_fun)
            n += 1
        end
        if !isborder(direct_robot)
            throw("Рядом с роботом отсутствует перегородка")
        end
        n = 0
        while isborder(direct_robot) && n < 4
            turn!(direct_robot, inv_rot_fun)
            n += 1
        end
        if isborder(direct_robot)
            throw("Робот ограничен со всех 4-х сторон")
        end
        #УТВ: Слева от робота перегородка и он может сделать шаг вперед
        return new(direct_robot, orientation)
    end
end

get_baserobot(robot::EdgeRobot) = get_baserobot(robot.direct_robot) # возвращает TypeRobot
get_direct(robot::EdgeRobot)::HorizonSide = get_direct(robot.direct_robot) # возвращает направление DirectRobot{TypeRobot}
get_orientation(robot::EdgeRobot)::Orientation = robot.orientation
#=
Функции, унаследованные от AbstractRobot:
    putmarker!(robot::EdgeRobot)
    ismarker(robot::EdgeRobot)
    temperature(robot::EdgeRobot)
=#

along!(stop_condition::Function, edge_robot::EdgeRobot) = while !stop_condition() 
    move!(edge_robot) 
end

along!(edge_robot::EdgeRobot, num_steps) = for _ in 1:num_steps 
    move!(edge_robot) 
end

"""
    inverse!(robot::EdgeRobot)::Nothing

-- инвертирует направление перемещений вдоль границы 
"""
function inverse!(robot::EdgeRobot)::Nothing 
    if robot.orientation == Positive
        #=
        Дано: слева - перегородка (или её нет, если только  робот - на углу), спереди - свободно
        Требуется: справа - перегородка (или её нет, если только робот - на углу), спереди - свободно
        =#    
        turn!(robot.direct_robot, left)
        while isborder(robot.direct_robot) # если только робот - на углу, то цикл невыполняется ни разу 
            turn!(robot.direct_robot, left)
        end
    else # robot.orientation == Negative
        # аналогично ...
        turn!(robot.direct_robot, right)
        while isborder(robot.direct_robot)
            turn!(robot.direct_robot, right)
        end
    end 
    robot.orientation = inverse(robot.orientation)
    return nothing
end


"""
move!(robot::EdgeRobot)
-- перемещает робота вперед вдоль границы в направлении EdgeRobot.orientation, и разворачивает его так, 
чтобы он мог сделать следующий шаг вперед вдоль границы 
"""
function HSR.move!(robot::EdgeRobot)::Nothing
    function turns!(turn_direct::Function, inv_turn_direct::Function)
        # Разворачивает робота так, чтобы слева/справа была граница, а спереди - свободно
        if !isborder(robot.direct_robot, turn_direct)
            turn!(robot.direct_robot, turn_direct)
        else
            while isborder(robot.direct_robot)
                turn!(robot.direct_robot, inv_turn_direct)
            end
        end
        return nothing 
    end
	
    move!(robot.direct_robot)  # - смещеает робота вперед на 1 клетку в направлении robot.direct_robot.direct
    # Далее выполняется разворот:
    if robot.orientation == Positive
        turns!(left, right) # УТВ: cлева - граница, спереди - свободно
    else # orientation == Negative 
        turns!(right, left) # УТВ: cправа - граница, спереди - свободно
    end 
    return nothing
end


function HSR.move!(robot::EdgeRobot, num_steps::Integer)::Nothing

    function turns!(turn_direct::Function, inv_turn_direct::Function)
        # Разворачивает робота так, чтобы слева/справа была граница, а спереди - свободно
        if !isborder(robot.direct_robot, turn_direct)
            turn!(robot.direct_robot, turn_direct)
        else
            while isborder(robot.direct_robot)
                turn!(robot.direct_robot, inv_turn_direct)
            end
        end
        return nothing 
    end

    for _ in 1:num_steps
        
        move!(robot.direct_robot)  # - смещеает робота вперед на 1 клетку в направлении robot.direct_robot.direct
        # Далее выполняется разворот:
        if robot.orientation == Positive
            turns!(left, right) # УТВ: cлева - граница, спереди - свободно
        else # orientation == Negative 
            turns!(right, left) # УТВ: cправа - граница, спереди - свободно
        end 
    end
    return nothing
end