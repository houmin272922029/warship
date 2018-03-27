--[[
	火炬行动7日奖励预览
	Author: Aaron Wei
	Date: 2016-01-08 17:40:35
]]

local PreviewDialog = qy.class("PreviewDialog", qy.tank.view.BaseDialog, "torch.ui.PreviewDialog")

function PreviewDialog:ctor()
    PreviewDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)

    self:InjectView("panel")

    -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(470,470),   
        position = cc.p(0,0),
        offset = cc.p(0,0), 
    })
    self:addChild(style)
    self.panel:retain()
    self.panel:getParent():removeChild(self.panel)
    style.bg:addChild(self.panel,0)
    self.panel:setPosition(235,235)
    self.panel:release()

    local awards = {}
    table.insert(awards,{["type"]=15,["id"]=3,["num"]=1})
    table.insert(awards,{["type"]=16,["id"]=3,["num"]=1})
    table.insert(awards,{["type"]=17,["id"]=3,["num"]=1})
    table.insert(awards,{["type"]=14,["id"]=4,["num"]=1})
    table.insert(awards,{["type"]=14,["id"]=3,["num"]=1})
    table.insert(awards,{["type"]=8,["id"]=0,["num"]=50})

	if not tolua.cast(self.awardList,"cc.Node") then
        self.awardList = qy.AwardList.new({
            ["award"] =  awards,
            ["hasName"] = false,
            ["type"] = 1,
            ["cellSize"] = cc.size(120,155),
            ["itemSize"] = 2, 
        })
        self.awardList:setPosition(-20,243)
        self.panel:addChild(self.awardList,0)
   	else
   		self.awardList:update(awards)
   	end

end

function PreviewDialog:onEnter()
    
end

function PreviewDialog:onExit()
    print("PreviewDialog:onExit")
end

function PreviewDialog:onCleanup()
    print("WorldBossView:onCleanup")
end

return PreviewDialog

