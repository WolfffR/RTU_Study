using HorizonSideRobots
include("moi_functii")
using HorizonSideRobots
sides = [Ost, Sud, West, Nord]
r = Robot("ss/inf_hor_border.sit",animate=true)
function proverka_sten(robot)
    for s in sides
        if isborder(robot,s)
            storona_sveta_steny = s
            return storona_sveta_steny
            break
        end
    end
    
end
function move_shag!(robot,side,kolvo)
    for s in 1:kolvo
        move!(robot,side)
    end
    
end
function kuda_idti(border_side)
    if border_side == Sud || border_side == Nord
        return [West, Ost]
    else
        return [Nord, Sud]
    end
    
end

function dvigaem!(robot,border_side)
    shag = 0
    ampl = 2
    pobeda = 0
    razbros = ampl
    napravlenie = kuda_idti(border_side)
    while pobeda == 0
        razbros = ampl
        for h in napravlenie
            razbros = ampl
            shag = 0
            for _ in  1:razbros
                move!(robot,h)
                shag += 1
                println("Ищу проход в стороне ", h, " shag = ", shag)
                if !isborder(robot, border_side)
                    println("Нашел границу на шаге ", shag)
                    pobeda == 1
                    return true
                    break
                end
                razbros -= 1

            end
            if isborder(robot, border_side)
                move_shag!(robot,inverse(h),shag)
                println("Проход не найден. Возвращаюсь в направлении ",inverse(h), " и сделал шагов ", shag)
                ampl += 5
            end
        end
    
    end  
    
end
function task7!(robot)
    x = proverka_sten(robot)
    dvigaem!(robot, x)
    
end
task7!(r)