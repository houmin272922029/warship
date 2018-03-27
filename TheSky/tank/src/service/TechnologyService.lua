--科技
local TechnologyService = qy.class("TechnologyService", qy.tank.service.BaseService)

TechnologyService.model = qy.tank.model.TechnologyModel

-- 主接口
function TechnologyService:getList(param, callback , isHide)
    local isShowLoading
    if isHide~=nil  and isHide==true then
        isShowLoading = false
    else
        isShowLoading = true
    end
    
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "technology.getList",
        ["p"] = param
    }))
    :setShowLoading(isShowLoading)
    :send(function(response, request)
        self.model:init(response.data)
        callback(response.data)
        qy.RedDotCommand:updateTechTemplateRedDot()
    end)
end

-- 激活
function TechnologyService:activate(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "technology.activation",
        ["p"] = param
    })):send(function(response, request)
        callback(response.data)
    end)
end

-- 升级
function TechnologyService:upgrade(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "technology.upgrade",
        ["p"] = param
    })):send(function(response, request)
        qy.RedDotCommand:emitSignal(qy.RedDotType.M_TECH, qy.tank.model.RedDotModel:isTechnologyHasRedDot())
        qy.RedDotCommand:updateTechTemplateRedDot()
        callback(response.data)
    end)
end

-- 十次升级
function TechnologyService:upgrade_plus(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "technology.upgrade_plus",
        ["p"] = param
    })):send(function(response, request)
        qy.RedDotCommand:emitSignal(qy.RedDotType.M_TECH, qy.tank.model.RedDotModel:isTechnologyHasRedDot())
        qy.RedDotCommand:updateTechTemplateRedDot()
        callback(response.data)
    end)
end


--新科技  金龙定义的破接口
function TechnologyService:getList2(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "technology.clear_index",
        ["p"] = {["armed_type"] = param}
    })):send(function(response, request)
        self.model:init2(response.data)
        qy.RedDotCommand:updateTechTemplateRedDot()
        callback(response.data)        
    end)
end

function TechnologyService:clear(armed_type, page_id, type, num, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "technology.clear",
        ["p"] = {["armed_type"] = armed_type, ["page_id"] = page_id, ["type"] = type, ["num"] = num}
    })):send(function(response, request)
        self.model:update(response.data)
        qy.RedDotCommand:updateTechTemplateRedDot()
        callback(response.data)
    end)
end

function TechnologyService:replace(armed_type, page_id, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "technology.clear_replace",
        ["p"] = {["armed_type"] = armed_type, ["page_id"] = page_id}
    })):send(function(response, request)
        self.model:update(response.data)
        qy.RedDotCommand:updateTechTemplateRedDot()
        callback(response.data)
    end)
end


function TechnologyService:change(armed_type, page_id, position, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "technology.clear_change",
        ["p"] = {["armed_type"] = armed_type, ["page_id"] = page_id, ["position"] = position}
    })):send(function(response, request)
        self.model:update(response.data)
        qy.RedDotCommand:updateTechTemplateRedDot()
        callback(response.data)
    end)
end


return TechnologyService