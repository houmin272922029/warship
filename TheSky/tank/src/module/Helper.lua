--[[
    模块加载入口
--]] 
local Helper = class("Helper")
local fileUtils = cc.FileUtils:getInstance()
local ASSETS_PATH = device.writablePath .. "assets/"

-- loaded_callback: 模块加载完成事件
function Helper:start(moduleName, args, loaded_callback)
    self._moduleName = moduleName
    self._args = args
    self._loaded_callback = loaded_callback

    if qy.has_module == 1 then
        -- local manifestDirectory = ASSETS_PATH .. "manifests"
        -- if not fileUtils:isDirectoryExist(manifestDirectory) then
            -- fileUtils:createDirectory(manifestDirectory)
        -- end
        -- local manifestFilePath = manifestDirectory .. "/" .. self._moduleName .. ".json"
        if self:hasMainLua() then
            -- 如果存在 main.lua,则表示该模块已加载过，不会继续加载(只加载一次，下次走热更新)
            self:onSuccess()
        else
            if qyoo.AssetsSingleton:isModuleExist(self._moduleName) then
                -- 模块存在
                qy.tank.view.module.Loader.new(self._moduleName,
                function()
                    self:onSuccess()
                    -- local manifestFile = io.open(manifestFilePath, "w")
                    -- manifestFile:write(qy.json.encode(os.time(),{indent = true}))
                    -- manifestFile:close()
                end):show()
            elseif qy.DEBUG then
                qy.hint:show("模块" .. self._moduleName .. "代码不存在")
            end
        end
    else
        self:onSuccess()
    end
end

function Helper:hasMainLua()
    if fileUtils:isFileExist(self._moduleName .. "/src/main.luac") or fileUtils:isFileExist(self._moduleName .. "/src/main.lua") then
        return true
    else
        print("找不到 main.lua")
        return false
    end
end

function Helper:onSuccess()
    if fileUtils:isFileExist(self._moduleName .. "/src/main.luac") or fileUtils:isFileExist(self._moduleName .. "/src/main.lua") then
        require(self._moduleName .. ".src.main")(self._args)
    else
        print("找不到 main.lua")
        if qy.DEBUG then
            qy.hint:show("找不到" .. self._moduleName .. "/src/main.lua,模块代码是否已经加载")
        end
    end
    if self._loaded_callback then
        self._loaded_callback()
    end
end

function Helper:register(name)
    print("该方法已经废弃了，为了防止报错，仅留下空方法")
end

return Helper
