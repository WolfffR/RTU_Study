using HorizonSideRobots
include("moi_functii.jl")
r = Border_Coord_Robot(Robot("ss/pereprava15.sit",animate = true))
# function HorizonSideRobots.move!(r :: CoordRobot, side :: HorizonSide)
#     move!(get_base_robot(r),side)
#     switch(side) do side
#         side==Nord && (r.y+=1)
#         side==Sud && (r.y-=1)
#         side==West && (r.x-=1)
#         side==Ost && (r.x+=1)
#     end
#     println((r.x, r.y))
    
#     if abs(r.y) == abs(r.x)
#         #sleep(1)
#         putmarker!(get_base_robot(r))
#         println((r.x, r.y), " поставлен маркер")
#     end
    
# end
# function slon_cross2!(robot, x_side, y_side)
#     x_s = false
#     y_s = false
#     if try_move!(robot, x_side)
#         try_move!(robot, inverse(x_side))
#         x_s = true
#     end
#     if try_move!(robot, y_side)
#         try_move!(robot, inverse(y_side))
#         y_s = true
#     end
#     if x_s && y_s
#         try_move!(robot, x_side)
#         try_move!(robot, y_side)
#         slon_cross2!(robot, x_side, y_side)
#     end
    
# end
# function return_home!(robot::BorderRobot, x::Integer, y::Integer, x_side, y_side)
#     try_move!(robot, x_side, x)
#     try_move!(robot, y_side, y)

# end
function task15!(robot)
    back = move_to_angle!(robot)
    snake_border!(robot; start_side=Nord, ortogonal_side=Ost)
    move_to_angle!(robot)
    move!(r, back)
end
task15!(r)