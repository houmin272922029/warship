--[[
	Tab切换
	Author: Aaron Wei
	Date: 2015-04-14 17:20:57
]]

local TabHost = qy.class("TabHost", qy.tank.view.BaseView)

--[[
    local tabHost = qy.tank.widget.TabHost.new({
        cds = "widget/TabButton1",
        tabs = {"全部", "宝箱", "材料", "道具"},
        size = cc.size(170,40),
        layout = "h",
        idx = 1,

        ["onCreate"] = function(tabHost, idx)
            return nil
        end,

        ["onTabChange"] = function(tabHost, idx)
        end
    })
]]

function TabHost:ctor(params)
    TabHost.super.ctor(self)

    if params then
        self.csd = params.csd or nil
        self.tabs = params.tabs or nil
        self.size = params.size or nil
        self.layout = params.layout or nil
        self.idx = params.idx or nil
        self.onCreate = params.onCreate
        self.onTabChange = params.onTabChange

        self.views = {}
        self.currentView = nil

        self.tab = qy.tank.widget.TabButtonGroup.new(self.csd,self.tabs,self.size,self.layout,function(idx)
            self:onSelectChange(idx)
        end,self.idx)
        self:addChild(self.tab)

        self:switchTo(self.idx)
    end
end

function TabHost:switchTo(idx)

end

function TabHost:__switchTabTo(idx)
    if self.tab then
        self.tab:switchTo(idx)
    end
end

function TabHost:__switchContentTo(idx)
    -- 移除当前视图
    if self.currentView then
        self:removeChild(self.currentView)
    end
    -- 显示新视图
    local view = nil
    if not self.views[idx] then
        view = assert(self.onCreate(self,idx),"创建view失败")
        view:retain()
        self.views[idx] = view
    else
        view = self.views[idx]
        if self.onTabChange then
            self.onTabChange(self,idx)
        end
    end
    self:addChild(view)
    -- 改变状态赋值
    self.currentView = view
    self.idx = idx
end

function TabHost:onSelectChange(idx)
    self:__switchContentTo(idx)
end

function TabHost:onCleanup()
    -- if self.views and #self.views>0 then
    --     for i=1,#self.views do
    --         local view  = self.views[i]
    --         view:release()
    --     end
    -- end
end

function TabHost:setTabNames(arr)
    self.tab:setTabNames(arr)
end

return TabHost
