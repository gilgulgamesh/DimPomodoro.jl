function slow_Add(a,b)
    println("tick")
    sleep(1)
    return a+b
end

function special_Mult(x, y::Function)
    if x == 0
        return 0
    elseif x == 1
        return y()
    else
        return y() + special_Mult(x - 1, y)
    end
end

result1 = special_Mult(0, () -> slow_Add(1, 2)) # Fast, as slow_Add is not called
result2 = special_Mult(1, () -> slow_Add(1, 2)) # slow_Add is called once
result3 = special_Mult(2, () -> slow_Add(1, 2)) # slow_Add is called twice
result4 = special_Mult(3, () -> slow_Add(1, 2)) # slow_Add is called three times

mutable struct LazyPair
    is_evaluated::Bool
    f::Any
end

function LazyPair(f::Function)
    return LazyPair(false, f)
end

function myForce(p::LazyPair)
    if (p.is_evaluated)
        return p.f
    else
        p.is_evaluated = true
        p.f = p.f()
    end
end

lazy_result1 = LazyPair(() -> special_Mult(0, () -> slow_Add(1, 2))) # Fast, as slow_Add is not called
lazy_result2 = LazyPair(() -> special_Mult(1, () -> slow_Add(1, 2))) # slow_Add is called once
lazy_result3 = LazyPair(() -> special_Mult(2, () -> slow_Add(1, 2))) # slow_Add is called twice
lazy_result4 = LazyPair(() -> special_Mult(3, () -> slow_Add(1, 2))) # slow_Add is called three times


result1 = myForce(lazy_result1) # Fast, as slow_Add is not called
result2 = myForce(lazy_result2) # slow_Add is called once
result3 = myForce(lazy_result3) # slow_Add is called twice
result4 = myForce(lazy_result4) # slow_Add is called three times
