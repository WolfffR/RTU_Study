using HorizonSideRobots
HSR = HorizonSideRobots

left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side)-1, 4))
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

try_move!(robot, side) = 
    if isborder(robot, side)
        return false
    else
        move!(robot, side)
        return true
    end


# Обобщенные функции, функции высшего порядка:

along!(stop_condition::Function, robot, side) = 
    while stop_condition() == false && try_move!(robot, side) end
 
function numsteps_along!(stop_condition::Function, robot, side)
    n = 0
    while stop_condition() == false && try_move!(robot, side)
        n += 1
    end
    return n
end

function snake!(stop_condition::Function, robot; start_side, ortogonal_side)
    s = start_side
    along!(stop_condition, robot, s)
    while !stop_condition() && !isborder(robot, ortogonal_side) # && try_move!(robot, ortogonal_side) - так будет лишняя попытка обхода внешней рамки
        move!(robot, ortogonal_side)
        s = inverse(s)
        along!(stop_condition, robot, s)
    end
end

snake!(robot; start_side, ortogonal_side) = 
    snake!(() -> false, robot; start_side, ortogonal_side)

function shatl!(stop_condition::Function, robot; start_side)
    s = start_side
    n = 0
    while stop_condition() == false
        n += 1
        move!(()->stop_condition(), robot, s, n)
        s = inverse(s)
    end
    return (n+1)÷2 # - число шагов от начального положения до конечного
end

function spiral!(stop_condition::Function, robot; start_side = Nord, nextside::Function = left)
    side = start_side
    n = 0
    while stop_condition() == false
        if iseven(n)
            n += 1
        end
        move!(()->stop_condition(), robot, side; num_maxsteps = n)
        side = nextside(side)
        move!(()->stop_condition(), robot, side; num_maxsteps = n)
        side = nextside(side)
    end
end
          
function HSR.move!(stop_condition::Function, robot, side; num_maxsteps::Integer)
    n = 0
    while n < num_maxsteps && stop_condition() == false
        n += 1
        move!(robot, side)
    end
    return n
end



#-------------- Конкретный пользовательский тип данных

# mutable struct Coordinates
#     x::Int
#     y::Int
# end

# function HSR.move!(coord::Coordinates, side::HorizonSide)
#     if side == Ost
#         coord.x += 1
#     elseif side == West
#         coord.x -= 1
#     elseif side == Nord
#         coord.y += 1
#     else # side == Sud
#         coord.y -= 1
#     end
#     nothing
# end

# get(coord::Coordinates) = (coord.x, coord.y)

