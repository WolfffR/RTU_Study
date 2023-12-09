v = [1,4,5,4,3,2]
function task27!(vector, current_sum=0, index=1)
    if index > length(vector)
        return current_sum
    else
        current_sum += vector[index]
        return task27!(vector, current_sum, index + 1)
    end
end
task27!(v)