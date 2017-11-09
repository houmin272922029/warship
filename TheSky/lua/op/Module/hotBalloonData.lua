
hotBalloonData = {
    data = {},
}

-- 获得热气球是否出现
function hotBalloonData:isShowBalloon(  )
    if hotBalloonData.data and hotBalloonData.data["times"] then
        if hotBalloonData.data["times"] > 0 then
            return true
        end 
    end

    return false
end

-- 向服务器获取热气球数据
function hotBalloonData:getHotBalloonData()
    local function getShakeInfoCallback( url, rtnData )
        if rtnData["info"] then
            hotBalloonData.data = rtnData["info"]["shakeData"]
        end
    end 
    doActionNoLoadingFun("GET_SHAKE_DATA_URL", {}, getShakeInfoCallback)
end

-- 设置热气球数据
function hotBalloonData:setHotData( data )
    hotBalloonData.data = data
end

--重置用户数据
function hotBalloonData:resetAllData()
    hotBalloonData.data = {}
end
