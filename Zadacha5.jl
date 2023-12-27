using HorizonSideRobots
include("moi_functii.jl")
r = Robot("ss/zd5.sit",animate=true)
function task5!(robot)

    side1 = Nord
    side2 = West

    x = go_along_shag!(robot,West)
    y = go_along_shag!(robot,Nord)
    while !isborder(robot,Nord) || !isborder(robot,West)
        if !isborder(robot,West)
            x+=go_along_shag!(robot,West)-1
            side1 = West
            side2 = Nord
        elseif !isborder(robot,Nord)
            y+=go_along_shag!(robot,Nord)-1
            side1 = Nord
            side2 = West
        end
    end

    perimetr!(robot)
    lenght = go_along_shag!(robot,Ost)
    go_along_shag!(robot,West)
    line=gofind(robot,lenght)
    markinnerperimetr(robot,line)
    println(1)
    to_corner!(robot,Nord,West)
    return_home!(robot,y,x,side1,side2)
    
end
task5!(r)