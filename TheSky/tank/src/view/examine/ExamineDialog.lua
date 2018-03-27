--[[
	查看资料
	Author: Aaron Wei
	Date: 2015-09-09 14:51:34	
]]

local ExamineDialog = qy.class("ExamineDialog", qy.tank.view.BaseDialog,"view/examine/ExamineDialog")

function ExamineDialog:ctor(kid, type)
	ExamineDialog.super.ctor(self)
    self.kid = kid
	-- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle2.new({
        size = cc.size(896,620),   
        position = cc.p(0,0),
        offset = cc.p(0,-20), 
        titleUrl = "Resources/common/title/chakan.png",
        
        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style,-1)

    self.model = qy.tank.model.ExamineModel
    self:InjectView("panel")
    self:InjectView("userName")
    self:InjectView("level")
    self:InjectView("rank")
    self:InjectView("userIconBG")
    self:InjectView("userIcon")
    self:InjectView("headerBG")
    self:InjectView("mailBtn")
    self:InjectView("Btn_more")


    if type == 1 or type == 2 then
        self.mailBtn:setVisible(false)
    end

    self:OnClick("mailBtn",function()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MAIL,{["defaultIdx"] = 3,["name"] = self.model.nickname})
        -- self:removeSelf()
    end)

    self:OnClick("fightBtn",function()

    end)

    self.page = 1
    self:OnClick("Btn_more",function()
        if self.page == 1 then
            self.page = 2
        else
            self.page = 1
        end
        self:update()
    end)
    
    self:update()

    print("role ====>>>>>>",qy.tank.utils.UserResUtil.getRoleIconByHeadType(self.model.headIcon))
    print(self.model.headIcon)
    self.userIcon:loadTexture(qy.tank.utils.UserResUtil.getRoleIconByHeadType(self.model.headIcon))
    self.userName:setString(self.model.nickname)
    self.level:setString("Lv."..tostring(self.model.level))
    if type ~= 2 then
        self.rank:setString(qy.TextUtil:substitute(4027).. " "..tostring(self.model.pvp_rank))
    else
        self.rank:setVisible(false)
    end
    self.fightPower = qy.tank.view.common.FightPower.new()
    self.fightPower:setPosition(240,25)
    self.headerBG:addChild(self.fightPower)
    self.fightPower:update(self.model.fight_power)    
end

function ExamineDialog:createContent(_idx)
    -- local layer = cc.LayerColor:create(cc.c4b(0,255,255,100),625,380)
    if self.page == 1 then
        if _idx == 1 then
        	self.tabView = qy.tank.view.examine.ExamineFormation.new(self.kid)
        elseif _idx == 2 then
        	self.tabView = qy.tank.view.examine.ExamineTech.new()
        elseif _idx == 3 then
        	self.tabView = qy.tank.view.examine.ExamineAchievement.new()
        elseif _idx == 4 then
            self.tabView = qy.tank.view.examine.ExamineSoul.new(self.kid)
        end
    else
        if _idx == 1 then
            self.tabView = qy.tank.view.examine.ExaminePassenger.new(self.kid)
        elseif _idx == 2 then
            self.tabView = qy.tank.view.examine.ExamineMedal.new(self.kid)
        end
    end

    return self.tabView
end

function ExamineDialog:update()
    if self.tab_host then
        self.panel:removeChild(self.tab_host)
        self.tab_host = nil
    end

    self.tab_host = qy.tank.widget.TabHost.new({
        delegate = self,
        csd = "widget/TabButton1",
        tabs = (self.page == 1 and {qy.TextUtil:substitute(10001), qy.TextUtil:substitute(10002), qy.TextUtil:substitute(10003), qy.TextUtil:substitute(48022)} 
                                or {qy.TextUtil:substitute(90315), qy.TextUtil:substitute(90316)}),
        size = cc.size(185,70),
        layout = "h",
        idx = 1,

        ["onCreate"] = function(tabHost, idx)
            return self:createContent(idx)
        end,
        
        ["onTabChange"] = function(tabHost, idx)
            -- tabHost.views[idx]:reloadData()
        end
    })

    self.panel:addChild(self.tab_host)
    self.tab_host.tab:setPosition(120,535)
end


return ExamineDialog