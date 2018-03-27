--[[
    图鉴弹框
    Author: mingming
    Date: 2015-08-21 16:28:15
]]

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "view/achievement/MainDialog")

function MainDialog:ctor(delegate)
    MainDialog.super.ctor(self)

    -- self:setCanceledOnTouchOutside(true)
    -- 通用弹窗样式
    self:InjectView("helpBtn")
    local style = qy.tank.view.style.DialogStyle2.new({
        size = cc.size(916,580),   
        position = cc.p(0,0),
        offset = cc.p(0,0), 
        titleUrl = "Resources/common/title/tanketujian.png", 
        
        ["onClose"] = function()
            self:clear()
            self:dismiss()
        end
    })
    self:addChild(style)
    self.style = style
    self.style:setLocalZOrder(-1)

    -- 内容样式
    self.delegate = delegate

    local userLevel = qy.tank.model.UserInfoModel.userInfoEntity.level
    local needAchievementLevel = qy.Config.function_open["20"].open_level
    
    self.tab_host = qy.tank.widget.TabHost.new({
        delegate = self,
        csd = "widget/TabButton1",
        -- tabs = userLevel >= needAchievementLevel and {"战车图鉴", "战车成就"} or {"战车图鉴"},
        tabs = {qy.TextUtil:substitute(1013), qy.TextUtil:substitute(1014)},
        size = cc.size(185,70),
        layout = "h",
        idx = 1,

        ["onCreate"] = function(tabHost, idx)
            if idx == 2 and userLevel < needAchievementLevel then
                qy.hint:show(qy.TextUtil:substitute(1015))
                tabHost.tab.btns[1]:setSelected(true)
                tabHost.tab.btns[2]:setSelected(false)
                return self:createContent(1)
            end
            return self:createContent(idx)
        end,
        
        ["onTabChange"] = function(tabHost, idx)
            if idx == 2 and userLevel < needAchievementLevel then
                qy.hint:show(qy.TextUtil:substitute(1015))
                tabHost.tab.btns[1]:setSelected(true)
                tabHost.tab.btns[2]:setSelected(false)
            end
            tabHost.views[idx]:update()
            self:changeTitle(idx)
        end
    })

    self:InjectView("purpleIron")
    self:InjectView("orangeIron")
    self:InjectView("Image_22_0")

    local winSize = cc.Director:getInstance():getWinSize()
    self.Image_22_0:setPositionX(winSize.width / 2 + 50)

    self:InjectView("panel")
    self.panel:setLocalZOrder(1)
    self.panel:setSwallowTouches(false)
    self.panel:addChild(self.tab_host)

    self.tab_host:setPosition(110, 535)
    self.tab_host.tab:setLocalZOrder(100)
    self.idx = 1
    self.helpBtn:setLocalZOrder(100)
   -- local function menuCall()
   --      qy.tank.view.common.HelpDialog.new(qy.tank.model.HelpTxtModel:getHelpDataByIndx(self.idx == 1 and 6 or 7)):show(true)
   --  end

    self:OnClick("helpBtn", function()
        --qy.QYPlaySound.stopMusic()
        qy.tank.view.common.HelpDialog.new(self.idx == 1 and 6 or 7):show(true)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    -- cc.MenuItemFont:setFontName("Resources/font/ttf/black_body_2.TTF")
    -- cc.MenuItemFont:setFontSize(24)

    -- local item = cc.MenuItemFont:create("说明")
    -- item:setColor(cc.c3b(46, 190, 83))
    -- item:registerScriptTapHandler(menuCall)
    -- item:setAnchorPoint(0,0.5)


    -- local menu = cc.Menu:create(item)
    -- qy.tank.utils.TextUtil:drawLine(item)

    -- menu:setPosition(885, 560)
    -- self.panel:addChild(menu)
    self:update()

    self.listener_d = qy.Event.add(qy.Event.ACHIEVEMENT_RESCOURES_CHANGE,function(event)
        self:update()
    end)
end

function MainDialog:createContent(_idx)
    -- local layer = cc.LayerColor:create(cc.c4b(0,255,255,100),625,380)
    if _idx == 1 then
        local view = qy.tank.view.achievement.PictureView.new()
        view:setPosition(-15, -456)
        return view
    elseif _idx == 2 then
        self.idx = _idx
        local view = qy.tank.view.achievement.AchievementView.new()
        return view
        -- return cc.Node:create()
    end
end

function MainDialog:changeTitle(idx)
    self.idx = idx
    -- self.style:update({["titleUrl" = ""]})
end

function MainDialog:update()
    self.purpleIron:setString(qy.tank.model.UserInfoModel.userInfoEntity.purpleIron)
    self.orangeIron:setString(qy.tank.model.UserInfoModel.userInfoEntity.orangeIron)
end

function MainDialog:clear()
    qy.Event.remove(self.listener_d)
end
function MainDialog:onExit()
    -- cc.Director:getInstance():getTextureCache():removeAllTextures()
end

return MainDialog


