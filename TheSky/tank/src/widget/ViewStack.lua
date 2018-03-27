--[[
说明: 视图栈, 用于先入后出的方式管理视图
作者: 林国锋 <guofeng@9173.com>
日期: 2014-11-11
]]

local ViewStack = qy.class("ViewStack", qy.tank.view.BaseView)

function ViewStack:ctor()
    ViewStack.super.ctor(self)

    self._views = {}
    self._isRetain = false
end

function ViewStack:isRetain(bool)
    self._isRetain = bool
    return self
end

-- 压入一个视图, 原来正在显示的视图将被暂时移除
function ViewStack:push(view,cleanup)
    -- if view then
    --     if not self._isRetain then
    --         self:removeAllChildren(false)
    --         view:retain()
    --         table.insert(self._views, view)
    --         self:addChild(view)
    --     else
    --         if self:currentView() and self.currentView().tag and view.tag and self.currentView().tag == view.tag then 
    --             -- 不重复添加
    --             print("ViewStack:push",self.currentView().tag,view.tag)
    --         else
    --             view:retain()
    --             table.insert(self._views, view)
    --             self:addChild(view)
    --         end
    --     end
    -- end

    if view then
        if self:currentView() and self:currentView().tag and view.tag and self:currentView().tag == view.tag then 
            -- 不重复添加
        else
            if not self._isRetain then
                self:removeAllChildren(cleanup == nil and true or cleanup)
            end
            view:retain()
            table.insert(self._views, view)
            self:addChild(view)
        end
    end
end

-- 弹窗一个视图, 之前被临时移除的视图会重新被显示
function ViewStack:pop()
    local view = table.remove(self._views)
    if view then
        view:release()
        self:removeChild(view)

        view = self:currentView()
        if view and not self._isRetain then
            self:addChild(view)
        end
    end
end

-- 替换当前视图为view, 被替换的视图将被永久删除
function ViewStack:replace(view)
    self:pop()
    self:push(view)
end

-- 弹出所有视图, 除了第一个
function ViewStack:popToRoot()
    local view = self._views[1]
    self:removeAllChildren()
    self:push(view)
    self._views = {}
    table.insert(self._views, view)
end

-- 销毁所有
function ViewStack:clean()
    self:removeAllChildren()
    self._views = {}
end

-- 获取当前正在显示的视图
function ViewStack:currentView()
    return self._views[#self._views]
end

function ViewStack:size()
    return #self._views
end

return ViewStack