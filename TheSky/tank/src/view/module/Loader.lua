--[[
    说明: 模块加载界面
]]

--[[
    说明: 模块加载界面
]]

local Loader = qy.class("Loader", qy.tank.view.BaseDialog, "view.module.Loader")

local EventCode = cc.EventAssetsManagerEx.EventCode

function Loader:ctor(module, loaded_callback)
    Loader.super.ctor(self)
    self._module = module
    self._loaded_callback = loaded_callback

    self:InjectView("LoadingBar_1")
    self:InjectView("Cursor_1")
    self:InjectView("Text_progress")
    self:InjectView("Sprite_7")
    self:InjectView("Text_1")

    self:startUpdata()
    self._changeSpare = false
end

function Loader:startUpdata()
    local amListener = cc.EventListenerAssetsManagerEx:create(qyoo.AssetsSingleton:getAssetsManagerEx(), function(event)
        local code = event:getEventCode()
        local assetId = event:getAssetId()

        if code == EventCode.UPDATE_PROGRESSION then
            if assetId ~= cc.AssetsManagerExStatic.MANIFEST_ID and assetId ~= cc.AssetsManagerExStatic.VERSION_ID then
                local percent = event:getPercent()
                local filepercent = event:getPercentByFile()
                self.LoadingBar_1:setPercent(percent)
                self.Text_progress:setString(string.format("%0.0f%%", filepercent))
                if qy.DEBUG then
                    print(assetId, string.format("%0.2f%%", percent), string.format("%0.2f%%", filepercent))
                end
            end
            if self._changeSpare then
                self.Text_1:setString("启用备用服务器，正在加载资源");
            else
                self.Text_1:setString("正在加载资源");
            end
        end
        if code == EventCode.ALREADY_UP_TO_DATE then
            self:onDismiss()
        end
        if code == EventCode.UPDATE_FINISHED then
            self.LoadingBar_1:setPercent(100)
            self.Text_progress:setString("100%")
            self:onDismiss()
        end

        if code == EventCode.ASSET_UPDATED then
        end

        if code == EventCode.DOWNLOAD_FAILED_CHANGE then
            self.Text_1:setString("下载服务器异常，正在更换备用服务器");
            self._changeSpare = true;
        end

        if code == EventCode.ERROR_UPDATING then
            self:onError()
        end

        if code == EventCode.UPDATE_FAILED then
            -- self:onError()
        end

        if code == EventCode.ERROR_DECOMPRESS then
            self:onError()
            qy.hint:show(qy.TextUtil:substitute(22001))
            if qy.DEBUG then
                print("解压失败", assetId)
            end
        end
    end)

    if amListener then
        self:getEventDispatcher():addEventListenerWithFixedPriority(amListener, 1)
    end
    self._amListener = amListener
    qyoo.AssetsSingleton:downloadModuleByName(self._module)
end

function Loader:onCleanup()
    if self._amListener then
        self:getEventDispatcher():removeEventListener(self._amListener)
    end
end

function Loader:onError()
    self:dismiss()
    qy.hint:show("下载失败，请重试")
end

function Loader:onDismiss()
    local _loaded_callback = self._loaded_callback
    self:dismiss()
    if _loaded_callback then
        _loaded_callback()
    end
end

return Loader