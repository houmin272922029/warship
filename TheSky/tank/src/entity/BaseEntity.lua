--[[
    说明: 基础实体类
    作者: 林国锋 <guofeng@9173.com>
    日期: 2014-12-03

    usage:

        local Hero = qy.class("Hero", qy.Entity.Base)

        function Hero:ctor()
            self:bindProperty({"level", 10, didSet = function(level)
                print(self.name .. " 等级变成" .. level)
            end})

            -- didSet 方法会在level的值发生变化的时候自动调用, 实现值的观察
        end
]]

local BaseEntity = class("BaseEntity")

function BaseEntity:ctor()
    self.__type = "entity"
end

function BaseEntity:bindProperty(name, value, didSet)
    if not self.properties then
        local mt = getmetatable(self)
        if not mt.__super then
            mt.__super = mt.__index
            -- 改写__index元方法, 优先从properties中取数据
            mt.__index = function(t, k)
                local properties = rawget(t, "properties")
                if properties then
                    local v = properties[k]
                    if v then
                        return v
                    end

                    -- 以"_"结尾
                    local n = string.sub(k, 1, string.len(k) - 1)
                    local methont = properties[n .. "_table"]
                    if methont then
                        return methont
                    end

                    v = properties[n]
                    if v then
                        local methont = {
                            name = n,
                            properties = properties,
                            get = function(self)
                                return self.properties[self.name]
                            end,
                            set = function(self, value)
                                local oldvalue = self:get()
                                self.properties[self.name] = value
                                local didSet = self.properties[self.name .. "_didSet"]
                                if didSet then
                                    didSet(self, oldvalue, value)
                                end
                            end
                        }
                        properties[n .. "_table"] = methont
                        return methont
                    end
                end
                return mt.__super[k]
            end
        end
        self.properties = {}
    end

    if not self.properties[name] then
        self.properties[name] = value
        if type(didSet) == "function" then
            self.properties[name .. "_didSet"] = didSet
        end
    else
        self[name .. "_"]:set(value)
    end
end

function BaseEntity:setproperty(name,value)
    -- self[name] = value
    self:bindProperty(name,value,callback)
end

function BaseEntity:isproperty(name)
    return type(self[name .. "_"]) == "table", self[name .. "_"]
end

function BaseEntity:updateAll(data)
    for name, value in pairs(data) do
        self:set(name, value)
    end
end

function BaseEntity:set(name, value)
    local f, p = self:isproperty(name)
    if f then
        p:set(value)
    end
end

function BaseEntity:get(name)
    return self[name]
end

return BaseEntity
