--[[--
	预览
	Author: H.X.Sun
--]]--

local Preview = qy.class("Preview", qy.tank.view.BaseView, "alloy/ui/Preview")

function Preview:ctor(delegate)
	Preview.super.ctor(self)

	local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "alloy/res/alloy_preview_title.png",
        showHome = true,
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })

    self:addChild(style, 13)
    self.model = qy.tank.model.AlloyModel
    self.delegate = delegate
    local service =require("alloy.src.AlloyService")

    self:InjectView("icon")
    self:InjectView("a_name")
    self:InjectView("num")
    self:InjectView("level")
    self:InjectView("right_bg")
    self.attriName = self.model:getAttributeNameByAlloyId(delegate.alloyId)

    self:OnClick("change_btn",function()
        delegate.showEmbeddedList()
    end,{["isScale"] = false})

    self:OnClick("unload_btn",function()
        service:unload({
            ["equipEntity"] = delegate.equipEntity,
            ["alloyEntity"] = self.alloyEntity,
        },function ()
            qy.tank.utils.HintUtil.showSomeImageToast(self.model:getAddAttribute(self.alloyEntity.alloy_id),cc.p(qy.winSize.width / 2, qy.winSize.height * 0.7))
            delegate.dismiss()
        end)
    end,{["isScale"] = false})

    self:OnClick("upgrade_btn",function()
        delegate.showEmbeddedView()
    end,{["isScale"] = false})
end

function Preview:updateAlloyInfo()
    -- local _entity = self.delegate.alloyEntity
    self.alloyEntity = self.model:getSelectAlloyByIndex(self.delegate.alloyId,self.delegate.equipEntity.unique_id)
    if self.alloyEntity then
        self.icon:setTexture(self.alloyEntity:getIcon())
        self.a_name:setString(self.alloyEntity:getName())
        self.a_name:setTextColor(self.model:getColorByLevel(self.alloyEntity.level))
        self.level:setString(qy.TextUtil:substitute(41027) .. " " ..self.alloyEntity.level)
        self.num:setString(qy.TextUtil:substitute(41028)..self.attriName .." : " .. self.alloyEntity:getAttribute())
    end
end

function Preview:createAttriViewList()
    self.attriViewList = {}
    local arr = self.model:getAttributeListByAlloyId(self.delegate.alloyId)
    local _w = qy.language == "cn" and 120 or 80
    local _h = 387
    for i = 1, #arr do
        self.attriViewList[i] = require("alloy.src.AlloyDescTxt").new(arr[i])
        self.right_bg:addChild(self.attriViewList[i])
        self.attriViewList[i]:setPosition(_w, _h - i * 37)
    end
end

function Preview:onEnter()
    if self.attriViewList == nil then
        self:createAttriViewList()
    end
    self:updateAlloyInfo()
end

return Preview
