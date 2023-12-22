using HorizonSideRobots
include("moi_functii.jl")
r = Robot(animate = true)
function double_redist!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        double_redist!(robot, side)
        try_move!(robot, inverse(side))
        try_move!(robot, inverse(side))
    end
        

    
end
task22!(robot, side) = double_redist!(robot, side)

#=
Как при этом можно было бы сделать так, чтобы в случае невозможности
переместить робота на удвоенное расстояние, в результате робот оставался бы в
исходном положении?

Если все шаги успешны = закончить программу
Если произощел false = воспроизвести сделанные шаги в обратном порядке 

=#