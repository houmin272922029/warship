--内存检测工具，用于朝赵内存泄露
--
--调用findObjectInGlobal(泄漏对象的引用)，即可找到一切非局部变量的归属关系
--
--addby lianyi 
local findedObjMap = nil 
function _G.findObject(obj, findDest)
    if findDest == nil then
        return false
    end
    if findedObjMap[findDest] ~= nil then
        return false
    end
    findedObjMap[findDest] = true

    local destType = type(findDest)
    if destType == "table" then
        if findDest == _G.CMemoryDebug then
            return false
        end
        for key, value in pairs(findDest) do
            if key == obj or value == obj then
                -- _info("Finded Object")
                print("Finded Object")
                return true
            end
            if findObject(obj, key) == true then
                -- _info("table key")
                print("table key")
                return true
            end
            if findObject(obj, value) == true then
                -- _info("key:["..tostring(key).."]")
                print("key:["..tostring(key).."]")
                return true
            end
        end
    elseif destType == "function" then
        local uvIndex = 1
        while true do
            local name, value = debug.getupvalue(findDest, uvIndex)
            if name == nil then
                break
            end
            if findObject(obj, value) == true then
                -- _info("upvalue name:["..tostring(name).."]")
                print("upvalue name:["..tostring(name).."]")
                return true
            end
            uvIndex = uvIndex + 1
        end
    end
    return false
end

function _G.findObjectInGlobal(obj)
    print("===================================")
    print("=                                 =")
    print("=       MemoryScan start          =")
    print("=                                 =")
    print("===================================")
    findedObjMap = {}
    setmetatable(findedObjMap, {__mode = "k"})
    _G.findObject(obj, _G)
    print("-----------------------------------")
    print("-                                 -")
    print("-       MemoryScan end            -")
    print("-                                 -")
    print("-----------------------------------")
end