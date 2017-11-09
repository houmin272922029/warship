-- 用户数据缓存

BLOOD_FIGHT_MAX = 3

blooddata = {
    data = {}, -- 数据
    -- battleInfo = {}, -- 对战信息
    -- outpostNum = 0, -- 当前挑战关卡数
    -- recordAll = 0, -- 当前获得多少星
    -- recordUsed = 0, -- 使用了多少星
    -- dayBuff = {}, -- buff加成
    -- skipNum = 0, -- 可以跳过的关卡
    -- best = {
    --     bestOutpostNum = 0, -- 最多闯关
    --     bestRecord = 0, -- 最多闯关获得星
    -- }, -- 今天最好的成绩
    -- flag = 0, -- 1 首页准备挑战， 2 有首次buff， 3 正在挑战， 4 有临时buff加成 5 奖励结算 6 失败
    -- todayRank = nil,
    -- count = 0, -- 今天已挑战次数
}

blooddataFlag = {
    home = 1,
    dayBuff = 2,
    fight = 3,
    tempBuff = 4,
    reward = 5,
    lose = 6,
}

function blooddata:fromDic(dic)
    blooddata.data = dic
end

--重置用户数据
function blooddata:resetAllData()
    -- blooddata.battleInfo = {} -- 对战信息
    -- blooddata.outpostNum = 0 -- 当前挑战关卡数
    -- blooddata.recordAll = 0 -- 当前获得多少星
    -- blooddata.recordUsed = 0 -- 使用了多少星
    -- blooddata.dayBuff = {} -- buff加成
    -- blooddata.skipNum = 0 -- 可以跳过的关卡
    -- blooddata.best = {
    --     bestOutpostNum = 0, -- 最多闯关
    --     bestRecord = 0, -- 最多闯关获得星
    -- } -- 今天最好的成绩
    -- blooddata.flag = 0 -- 1 首页准备挑战， 2 有首次buff， 3 正在挑战， 4 有临时buff加成 5 奖励结算 6 失败
    -- blooddata.todayRank = nil
    -- blooddata.count = 0 -- 今天已挑战次数
    blooddata.data = {}
end



