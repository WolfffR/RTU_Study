using HorizonSideRobots
include("moi_functii")

function task28!(n)
    i = 0
    fib_sum = 0
    fib1 = 1
    fib2 = 1

    while i < n - 2
        fib_sum = fib1 + fib2
        fib1 = fib2
        fib2 = fib_sum
        i = i + 1
    end
    return fib2
end

function task28_re!(n)
    if n <= 1
        return n
    else
        return (task28_re!(n-1) + task28_re!(n-2))
    end
end

function task28_re_me!(n, memo = Dict())
    if n <= 1
        return n
    elseif haskey(memo, n)
        return memo[n]
    else
        memo[n] = task28_re_me!(n-1, memo) + task28_re_me!(n-2, memo)
        return memo[n]
    end
end