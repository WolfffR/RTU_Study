using HorizonSideRobots
dir = "/Users/egordruk/Desktop/uop/types_of_robot"

filter_my(c) = !startswith(c, ".")
# Получаем список файлов в папке
files = readdir(dir)
files = filter(filter_my, files)
# Проходим по каждому файлу и включаем его
for file in files
    include("types_of_robot/" * file)
end
HSR = HorizonSideRobots

sides = [Ost, Sud, West, Nord]


#r = Robot("ss/center.sit",animate = true)




left(side::HorizonSide) = HorizonSide(mod(Int(side) + 1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side) - 1, 4))
inverse(side::HorizonSide) = HorizonSide(mod(Int(side) + 2, 4))


function HSR.move!(stop_condition::Function, robot, num_maxsteps::Integer; side)
    n = 0
    while n < num_maxsteps && stop_condition() == false
        n += 1
        move!(robot, side)
    end
    return n
end
HSR.move!(robot, side, num_steps::Integer) =
    for _ ∈ 1:num_steps
        move!(robot, side)
    end

HorizonSideRobots.move!(robot, side::NTuple{2,HorizonSide}) =
    for s in side
        move!(robot, s)
    end


function try_move!(robot, side)::Bool
    if isborder(robot, side)
        return false
    else
        move!(robot, side)
        return true
    end

end
function try_move!(robot, side, n::Integer)::Bool
    if isborder(robot, side)
        return false
    else
        move!(robot, side)
        return true
    end

end
function along!(robot, side)
    while !isborder(robot, side)
        try_move!(robot, side)
    end
end


along!(stop_condition::Function, robot, side) =
    while stop_condition() == false && try_move!(robot, side)
    end
#along!(stop_condition::Function, robot, side) = 
#  while stop_condition() == false && try_move!(robot, side) 
# end
function go_along_shag!(robot, side)
    num_steps = 0
    while !isborder(robot, side)
        move!(robot, side)
        num_steps += 1
    end
    return num_steps
end
"""
   ## `perimetr!(robot)`
-- Красит периметр внешней рамки с **Северо-Западного** угла по порядку `[Ost, Sud, West, Nord]`
"""
function perimetr!(robot)
    for s in sides
        while !isborder(robot, s)
            putmarker!(robot)
            move!(robot, s)
        end
    end

end
"""
Ставит робота в угол
"""
function to_corner!(robot, x_side, y_side)
    x = go_along_shag!(robot, x_side)
    y = go_along_shag!(robot, y_side)
    return [x, y]
end

function any_border(robot)
    for s in sides
        if isborder(robot, s)
            return true
        else
            return false
        end
    end

end

HorizonSideRobots.isborder(robot, side::NTuple{2,HorizonSide}) =
    isborder(robot, side[1]) || isborder(robot, side[2])

"""
-- Возвращает сторону где есть граница в порядке *[Ost, Sud, West, Nord]*
    
Если стены нет - вернет `false`
"""
function target_border(robot)
    for s in sides
        if isborder(robot, s)
            return s
        else
            return false
        end
    end

end

"""
    return_home!(robot::Any,l::Array, x_side, y_side)
-- Возвращает robot::Any на место

"""
function return_home!(robot::AbstractRobot, l::Array, x_side, y_side)
    move!(robot, x_side, l[1]::Integer)
    move!(robot, y_side, l[2]::Integer)

end
function return_home!(robot::Any, x::Integer, y::Integer, x_side, y_side)
    move!(robot, x_side, x)
    move!(robot, y_side, y)

end

function snake!(stop_condition::Function, robot; start_side, ortogonal_side)
    s = start_side
    along!(robot, s) do
        stop_condition() || isborder(robot, s)
    end
    while !stop_condition() && try_move!(robot, ortogonal_side)
        s = inverse(s)
        along!(robot, s) do
            stop_condition() || isborder(robot, s)
        end
    end
end
function snake!(robot; start_side, ortogonal_side)
    s = start_side
    along!(robot, s) do
        isborder(robot, s)
    end
    while try_move!(robot, ortogonal_side)
        s = inverse(s)
        along!(robot, s) do
            isborder(robot, s)
        end
    end
end

"""
Заставляет кружиться робота по спирали пока условие остнаовки false
"""

function fast_move_marker!(stop_condition::Function, robot, b, side)

    for i in 1:b

        if !stop_condition()
            move!(robot, side)
        else
            break
        end

    end

end

function spiral!(stop_condition::Function, robot; start_p, rotation::Function)
    b = 1
    start_p = West
    a = start_p
    while stop_condition() == false
        fast_move_marker!(stop_condition, robot, b, a)
        a = rotation(a)
        if a == start_p || a == inverse(start_p)
            b += 1
        end


    end

end


"""
         num_steps_along!(robot, direct)::Int
    -- перемещает робота в заданном направлении до упора и
    возвращает число фактически сделанных им шагов
    """
function num_steps_along!(robot, direct)::Int
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        num_steps += 1
    end
    return num_steps
end

"""
numsteps_along!(robot, direct, max_num_steps)::Int
-- перемещает робота в заданном направлении до упора, если необходимое для этого число шагов не превосходит max_num_steps, или на max_num_steps шагов, и возвращает число фактически сделанных им шагов
"""
function numsteps_along!(robot, direct, max_num_steps)::Int
    num_steps = 0
    while num_steps < max_num_steps && try_move!(robot, direct)
        #- здесь принципиально, что операция && является “ленивой”
        num_steps += 1
    end
    return num_steps
end

"""
    try_move!(robot, direct)::Bool
-- делает попытку одного шага в заданном направлении и
26
возвращает true, в случае, если это возможно, и false - в
противном случае (робот остается в исходном положении)
"""
try_move!(robot, direct) = (!isborder(robot, direct) && (move!(robot, direct); return true); false)



"""
До упора в стену
"""
function re_along!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        re_along!(robot, side)
    end

end

"""
## `step!(robot, side)`
-- рекурсивная функция шага в сторону и обхода конечной перегородки нулевой ширины
"""
function step!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
    else
        move!(robot, left(side))
        step!(robot, side)
        move!(robot, right(side))
    end
end

"""
**Требуется удвоить расстояние от робота до перегородки, находящейся с
заданного направления**
"""
function double_dist!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        double_dist!(robot, side)
    else
        move!(robot, inverse(side))
        move!(robot, inverse(side))
    end
end

"""
**Требуется переместить робота в позицию, симметричную по отношению к
перегородке, находящейся с заданного направления, т.е. требуется поставить
робота на таком же расстоянии от противоположной перегородки**
"""
function to_symm_pos!(robot, side)
    if isborder(robot, side)
        re_along!(robot, inverse(side))
    else
        move!(robot, side)
        to_symm_pos!(robot, side)
        move!(robot, side)
    end
end

function move_to_angle!(robot)
    return (side=Nord, num_steps=go_along_shag!(robot, Sud)),
    (side=Ost, num_steps=go_along_shag!(robot, West)),
    (side=Nord, num_steps=go_along_shag!(robot, Sud))
end
function move_to_back!(robot, back_path)
    for next in back_path
        along!(robot, next.side, next.num_steps)
    end
end

"""
move
_
to
_angle!(robot)
87
-- перемещает робота в заданный угол (угол задается
кортежем из двух значений HorizonSide), последовательно
перемещаясь до упора в одном из двух заданных направлений.
-- возвращает "обратный путь" в виде вектора
(многоэлементного, вообще говоря) из именованных кортежей,
с именами полей: side, num_steps
"""
function move_to_angle!(robot, angle=(Sud, West))::Vector{NamedTuple{(:side, :num_steps),Tuple{HorizonSide,Int}}}
    back_path = NamedTuple{(:side, :num_steps),Tuple{HorizonSide,Int}}[]
    # - пустой вектор типа Vector{Tuple{HorizonSide,Int}}
    while !isborder(robot, angle[1]) || !isborder(robot, angle[2])
        push!(back_path, (side=inverse(angle[2]),
            num_steps=go_along_shag!(robot, angle[2])))
        push!(back_path, (side=inverse(angle[1]),
            num_steps=go_along_shag!(robot, angle[1])))
    end
    return reverse(back_path)
end

function HorizonSideRobots.move!(robot::Robot, back_path::Vector{NamedTuple{(:side, :num_steps),Tuple{HorizonSide,Int}}})
    for next in back_path
        move!(robot, next.side::Any, next.num_steps::Int)
    end
end

function num_horizontal_borders!(robot)
    back_path = move_to_angle!(robot)
    println(back_path)
    side = Ost
    num_borders = num_horizontal_borders!(robot, side)
    while !isborder(robot, Nord)
        move!(robot, Nord)
        side = inverse(side)
        num_borders += num_horizontal_borders!(robot, side)
    end
    to_corner!(robot, West, Sud) ## Доработано, чтобы он вернулся в место старта обхода
    move!(robot, back_path)
    return num_borders
end

function num_horizontal_borders!(robot, side)
    # 1-ый способ
    num_borders = 0
    state = 0 # в направлении Nord внутренней перегородкинет (но может быть внешняя рамка)
    while !isborder(robot, side)
        move!(robot, side)
        if state == 0
            if isborder(robot, Nord) == true
                state = 1 # обнаружено начало очередной перегородки
            end
        else # state == 1
            if isborder(robot, Nord) == false
                state = 0
                num_borders += 1
            end
        end
    end
    return num_borders
end



function num_horizontal_borders_razriv!(robot, razriv::Int)
    back_path = move_to_angle!(robot)
    println(back_path)
    side = Ost
    num_borders = num_horizontal_borders!(robot, side, razriv)
    while !isborder(robot, Nord)
        move!(robot, Nord)
        side = inverse(side)
        num_borders += num_horizontal_borders!(robot, side, razriv)
    end
    to_corner!(robot, West, Sud) ## Доработано, чтобы он вернулся в место старта обхода
    move!(robot, back_path)
    return num_borders
end

function num_horizontal_borders!(robot, side, razriv::Int)
    # 1-ый способ
    num_borders = 0
    propuski = 0
    state = 0 # в направлении Nord внутренней перегородкинет (но может быть внешняя рамка)
    while !isborder(robot, side)
        move!(robot, side)
        if state == 0
            if isborder(robot, Nord) == true
                state = 1 # обнаружено начало очередной перегородки
                println("Нашел новую перегородку")
            end
        else # state == 1
            if isborder(robot, Nord) == false
                propuski += 1
                println("пропуск")
                if propuski > razriv || isborder(robot, side)
                    state = 0
                    num_borders += 1
                    propuski = 0
                    println("посчитал перегородку ", num_borders)
                end
            else
                propuski = 0
            end








            # if isborder(robot, Nord) == false
            #     if isborder(robot, side) == true || propuski > razriv
            #         state = 0
            #         num_borders += 1
            #         propuski = 0
            #         println("посчитал перегородку ", num_borders)
            #     else # по ходу робота нет стены
            #         propuski += 1
            #         println("пропуск ")
            #         if propuski > razriv
            #             state = 0
            #             num_borders += 1
            #             propuski = 0
            #             println("посчитал перегородку ", num_borders)
            #         end
            #     end
            # end





        end
    end
    return num_borders
end


function gofind(robot, lenght)

    side = Ost
    lenght1 = 1
    finder = true
    line = 1

    while !(isborder(robot, Sud) && isborder(robot, Ost)) && finder
        while !isborder(robot, side) && finder
            lenght1 += 1
            move!(robot, side)
        end
        if !isborder(robot, Sud) && (lenght1 == lenght)
            move!(robot, Sud)
            lenght1 = 1
            side = inverse(side)
            line += 1
        elseif lenght1 !== lenght
            finder = !finder
        end
    end
    return line

end

function markinnerperimetr(robot, line)

    if line % 2 == 0
        side = West
    elseif line % 2 == 1
        side = Ost
    end

    for i in 1:5
        while isborder(robot, side)
            putmarker!(robot)
            move!(robot, right(side))
        end
        putmarker!(robot)
        move!(robot, side)
        side = left(side)
    end

end

function snake_border!(robot; start_side, ortogonal_side)
    s = start_side
    along!(robot, s) do
        isborder(robot, s)
    end
    while try_move!(robot, ortogonal_side)
        s = inverse(s)
        along!(robot, s)
    end
end


