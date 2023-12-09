using HorizonSideRobots
include("moi_functii")
r = Robot(animate = true)
function re_half_distance!(robot, side)
    function re_dva!(robot, side)
        if try_move!(robot, side)
            re_half_distance!(robot, side)
            move!(robot, inverse(side))
        end
    end
    if try_move!(robot,side)
        re_dva!(robot, side)
    end
end
task24!(robot, side) = re_half_distance!(robot, side)
re_half_distance!(r, Ost)