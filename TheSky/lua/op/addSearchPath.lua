local sharedApplication = CCApplication:sharedApplication()
local target = sharedApplication:getTargetPlatform()
print("target is " .. target)
if target == kTargetWindows then
    devicePlatform = "windows"
elseif target == kTargetMacOS then
    devicePlatform = "mac"
elseif target == kTargetAndroid then
    devicePlatform = "android"
elseif target == kTargetIphone or target == kTargetIpad then
    devicePlatform = "ios"
end

if newUpdate and newUpdate() then
    TEMP_PATH = fileUtil:getCachePath()

if devicePlatform == "android" then
    TEMP_PATH = TEMP_PATH .. "cache/"
end
    fileUtil:addSearchPath("ccbResources/")
    fileUtil:addSearchPath("lua/")

    fileUtil:addSearchPath(CONF_PATH)
    fileUtil:addSearchPath(CONF_PATH .. "ccbResources/")
    fileUtil:addSearchPath(CONF_PATH .. "lua/")
end



-- if device.platform == "windows" then
--     fileUtil:addSearchPath("res/sc/ccbi/")
--     fileUtil:addSearchPath("res/pubImages/")
--     fileUtil:addSearchPath("res/pubImages/ccbResources/")
--     fileUtil:addSearchPath("res/sc/fontImages/")
--     fileUtil:addSearchPath("res/sc/fontImages/ccbResources/")
--     fileUtil:addSearchPath("res/")
--     fileUtil:addSearchPath("scripts/")
-- else
    -- fileUtil:addSearchPath("images/")
    -- fileUtil:addSearchPath("ccbResources/")
    -- fileUtil:addSearchPath("lua/")

    -- fileUtil:addSearchPath(CONF_PATH)
    -- fileUtil:addSearchPath(CONF_PATH .. "images/")
    -- fileUtil:addSearchPath(CONF_PATH .. "ccbResources/")
    -- fileUtil:addSearchPath(CONF_PATH .. "lua/")
-- end


--[[

文件是否存在
@ param string fileName 文件名称
@ return bool

]]
function isFileExist( fileName )
    
    return fileUtil:isFileExist(fileUtil:fullPathForFilename(fileName))
end

-- 删除文件
function deleteFile(filePath)
    return GameHelper:deleteDir(filePath)
end

function createDir(filePath)
    return GameHelper:createDir(filePath)
end

function copyDirFile(srcPath, destPath)
    return GameHelper:copyDirFile(srcPath, destPath)
end

function copyFile(src, dest)
    return GameHelper:copyFile(src, dest)
end

-- 读取json文件，返回table数据，不存在则返回空table
function readJsonFile(path)

    local versionFiles
    xpcall(
        function ()
            -- 以只读模式打开
            local file = io.open(path)
            -- 读取所有内容
            local versionFile = file:read("*a")
            file:flush()
            file:close()
            versionFiles = json.decode(versionFile)
        end,
        function ()
            trace("Can't read version file,please check if "..path.." exist!")
        end
    )

    return versionFiles or {}
end