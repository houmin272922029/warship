
yield   = coroutine.yield
co      = function(func, cb)
    local cor = coroutine.create(func)
    local next = coroutine.resume
    local hasNext; hasNext = function(status, func, ...)
        -- suspended
        if not status then
            print(func)
        else
            -- only function
            if type(func) == "function" then
                -- call function
                func(--[[callback]]function(...)
                    hasNext(next(cor, ...))
                end)
            elseif cb then
                cb(func, ...)
            end
        end
    end
    hasNext(next(cor))
end

-- test
--[[
function hello(hah)
    return function(next)
        next("hello " .. hah)
    end
end

function world(next)
    next("world")
end

co(function()
    local a = yield(hello("hah"))
    local b = yield(world)
    print("result:", a .. " " .. b)
end)
]]
