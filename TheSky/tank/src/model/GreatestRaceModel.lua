--[[--
    最强之战model
    Author: H.X.Sun
--]]

local GreatestRaceModel = qy.class("GreatestRaceModel", qy.tank.model.BaseModel)

local UserInfoModel = qy.tank.model.UserInfoModel
local LoginModel = qy.tank.model.LoginModel
local BattleModel = qy.tank.model.BattleModel

-- 【前端流程控制】
GreatestRaceModel.STATUS_SUSPEND = 0    -- 停赛
GreatestRaceModel.STATUS_SIGN_UP = 1    -- 报名
GreatestRaceModel.STATUS_GROUP = 2      -- 分组
GreatestRaceModel.STATUS_MATCH = 3      -- 比赛
GreatestRaceModel.STATUS_PROMOTION = 4  -- 晋级
GreatestRaceModel.STATUS_RANK = 5       -- 排名

GreatestRaceModel.STAGE_PRE = 1     -- 预赛
GreatestRaceModel.STAGE_EARLY = 2   -- 初赛
GreatestRaceModel.STAGE_SEMI = 3    -- 复赛
GreatestRaceModel.STAGE_FINAL = 4   -- 决赛

GreatestRaceModel.ACTION_GROUP = 1      -- 比赛期间STATUS_MATCH，分组(只有决赛，才有比赛期间分组)
GreatestRaceModel.ACTION_SYNC = 2       -- 比赛期间STATUS_MATCH，同步阵法
GreatestRaceModel.ACTION_SUPPORT = 3    -- 比赛期间STATUS_MATCH，支持
GreatestRaceModel.ACTION_CALC = 4       -- 比赛期间STATUS_MATCH，计算战斗
GreatestRaceModel.ACTION_WAIT = 5       -- 等待

GreatestRaceModel.ID_MATCH = 1      -- 参赛者
GreatestRaceModel.ID_SUPPORT = 2    -- 支持者

-- 【后端流程控制】
--[[
    global：包含整体流程控制信息：
    stage: 1报名 2预赛 3预赛后展示 4初赛 5初赛后展示 6复赛 7复赛后展示 8决赛 9决赛后展示 10报名阶段：人数不够
    status: 预赛，初赛，复赛，决赛时使用：1分组 2同步阵型 3支持  4计算战斗
    round：轮次，预赛初赛复赛1-15轮，决赛：32=32强赛，16=16强赛，8=8强，4=4强，2-半决赛，1=决赛与季军赛
    game_num：局数，预赛初赛复赛都是1，决赛为1-3局
    next_time：下一个状态变化的时间节点，这个控制 status 1-2/3-4之间的流转
    next_play_time 下一局开始的时间，这个给前端用来展示战斗的时间点
    stage不同，返回的数据不同
    indenty：身份：1参赛者，2是观战者
]]--


function GreatestRaceModel:init(data)
    self:updateStage(data)

    if self.current_status == self.STATUS_MATCH then
        if self.data and self.data.vs_info then
            self:initSupportNum(self.data)
        else
            self:initSupportNum(data)
        end
        self.last_support_arr = clone(self.support_num_arr)
        self.show_support_arr = clone(self.support_num_arr)
    end

    self.data = data
    self:update(data)
end

function GreatestRaceModel:clearSupportNum()
    if self.data and self.data.vs_info then
        self.data.vs_info.att_support_num = 0
        self.data.vs_info.def_support_num = 0
    end
end

function GreatestRaceModel:initSupportNum(data)
    if data == nil then
        data = self.data
    end
    self.support_num_arr = {}
    self.support_num_arr[1] = self:calculateSupportNum(data.vs_info.att_support_num or 0)
    self.support_num_arr[2] = self:calculateSupportNum(data.vs_info.def_support_num or 0)
end

function GreatestRaceModel:updateStage(data)
    self.current_status = 0 -- 当前状态
    self.current_stage = 0  -- 当前赛段(仅在一写需要展示赛段的界面)
    if data.global.stage == 1 then
        -- 后端数据：stage 1 报名
        self.current_status = self.STATUS_SIGN_UP
    elseif data.global.stage == 10 or data.global.stage == 0 then
        -- 后端数据：stage 10报名阶段：人数不够
        self.current_status = self.STATUS_SUSPEND
    elseif data.global.stage == 9 then
        -- 后端数据：stage 9决赛后展示
        self.current_status = self.STATUS_RANK
    elseif data.global.stage == 3 or data.global.stage == 5 or data.global.stage == 7 then
        -- 后端数据：stage 3预赛后展示 5初赛后展示 7复赛后展示
        self.current_status = self.STATUS_PROMOTION
    elseif data.global.stage == 8 then
        -- 后端数据：stage 8决赛
        self.current_status = self.STATUS_MATCH
    else
        -- 后端数据：stage 2预赛 4初赛 6复赛
        if data.global.status == 1 then
            -- 后端数据 status 1分组
            self.current_status = self.STATUS_GROUP
        else
            -- 后端数据 status 2同步阵型 3支持 4计算战斗
            self.current_status = self.STATUS_MATCH
        end
    end
end

function GreatestRaceModel:isFinalRound(log_data)
    if log_data then
        if log_data.stage == 8 then
            if log_data.att_is_up == 1 or log_data.def_is_up == 1 then
                return true
            end
        elseif log_data.round == 15 then
            return true
        end
    else
        if self.current_stage == self.STAGE_FINAL then
            if self.data.global.att_is_up == 1 or self.data.global.def_is_up then
                return true
            end
        else
            if self.data.global.round == 15 then
                return true
            end
        end
    end
    return false
end

function GreatestRaceModel:update(data)
    if data.enter_level then
        self.enter_level = data.enter_level
    end
    if data.watch_level then
        self.watch_level = data.watch_level
    end
    if data.rank then
        self.rank_list = data.rank
    end
    self.data = data

    self.current_id = data.indenty -- 当前身份
    self.current_action = data.global.status -- 当前动作

    self.current_stage = self:__getStage(data.global.stage)

    self:setSignUpStatus(data)

    self.increase_support = {0,0}
    self.update_match_time = 10

    self:updateVsInfo()

    self.current_mon = data.mon
end

function GreatestRaceModel:getCurrentMon()
    return self.current_mon
end

function GreatestRaceModel:getMyRank()
    if self.data.my_rank and self.data.my_rank > 0 then
        return self.data.my_rank
    else
        return "暂无排名"
    end
end

function GreatestRaceModel:getAttResults()
    local data = {}
    data.win_times = (tonumber(self.data.vs_info.att_vs_win_times) or 0)
    data.fail_times = (tonumber(self.data.vs_info.def_vs_win_times) or 0)
    return data
end

function GreatestRaceModel:updateVsInfo()
    self.att_info = nil
    self.def_info = nil
    local att_support, def_support, log_data
    if self.data.vs_info then
        local vs_info = self.data.vs_info
        if (vs_info.def_vs_win_times or 0) < 2 then
            if vs_info.att_kid and vs_info.att_kid > 0 then
                self.att_info = {}
                self.att_info["name"] = vs_info.att_nickname .. " " .. "Lv."..vs_info.att_level
                local district = LoginModel:getDistrictById(vs_info.att_server)
                self.att_info["server"] = "【" ..district.s_name .. " " .. district.name .. "】"
                self.att_info["results"] = vs_info.att_win_times .. "胜" .. vs_info.att_fail_times .. "负"
                self.att_info["legion"] = (vs_info.att_legion_name == "" and "未加入军团" or vs_info.att_legion_name)
                self.att_info["rank"] = (self.data.att_rank == 0 and "暂无排名" or self.data.att_rank)
                self.att_info["headicon"] = vs_info.att_headicon
                self.att_info["kid"] = vs_info.att_kid
                att_support = vs_info.att_support_num
                self.att_info["log"] = {}
                for i = 1, #self.data.att_log do
                    log_data = self.data.att_log[i]
                    log_data.front_stage = self:__getStage(log_data.stage)
                    local title = self:__getMatchTitle(log_data)
                    self.att_info["log"][i] = {
                        ["title"]=title,
                        ["vs"]=log_data.att_nickname.." VS "..log_data.def_nickname,
                        ["id"] = log_data.id
                    }
                end
            end
        else
            self.current_action = self.ACTION_WAIT
        end
        if (vs_info.att_vs_win_times or 0 ) < 2 then
            if vs_info.def_kid and vs_info.def_kid > 0 then
                self.def_info = {}
                self.def_info["name"] = vs_info.def_nickname .. " " .. "Lv."..vs_info.def_level
                local district = LoginModel:getDistrictById(vs_info.def_server)
                self.def_info["server"] = "【" ..district.s_name .. " " .. district.name .. "】"
                self.def_info["results"] = vs_info.def_win_times .. "胜" .. vs_info.def_fail_times .. "负"
                self.def_info["legion"] = (vs_info.def_legion_name == "" and "未加入军团" or vs_info.def_legion_name)
                self.def_info["rank"] = (self.data.def_rank==0 and "暂无排名" or self.data.def_rank)
                self.def_info["headicon"] = vs_info.def_headicon
                self.def_info["kid"] = vs_info.def_kid
                def_support = vs_info.def_support_num
                self.def_info["log"] = {}
                for i = 1, #self.data.def_log do
                    log_data = self.data.def_log[i]
                    log_data.front_stage = self:__getStage(log_data.stage)
                    local title = self:__getMatchTitle(log_data)
                    self.def_info["log"][i] = {
                        ["title"]=title,
                        ["vs"]=log_data.att_nickname.." VS "..log_data.def_nickname,
                        ["id"] = log_data.id
                    }
                end
            end
        else
            self.current_action = self.ACTION_WAIT
        end
        if self.att_info == nil then
            self.att_info = self.def_info
            self.def_info = nil
        end
        self:setSupportNum(att_support,def_support)
    end
end

function GreatestRaceModel:isSupported()
    if self.data.watch and self.data.watch.support_kid and self.data.watch.support_kid > 0 then
        return true
    else
        return false
    end
end

function GreatestRaceModel:getVsDataByUserIndex(index)
    if index == 0 then
        return self.att_info
    else
        return self.def_info
    end
end

function GreatestRaceModel:getRoundTitle()
    if self.data.global.game_num and self.data.global.game_num>0 then
        return "第" .. self.data.global.game_num .. "轮"
    else
        return "第1轮"
    end
end

function GreatestRaceModel:__getStage(_stage)
    local front_stage = 0
    if _stage == 2 or _stage == 3 then
        front_stage = self.STAGE_PRE
    elseif _stage == 4 or _stage == 5 then
        front_stage = self.STAGE_EARLY
    elseif _stage == 6 or _stage == 7 then
        front_stage = self.STAGE_SEMI
    elseif _stage == 8 or _stage == 9 then
        front_stage = self.STAGE_FINAL
    end

    return front_stage
end

--[[
    参数 param
    param.front_stage:前端目前的赛段
    param.round: 第几局
    param.vs_num: 1:冠军赛 2：季军赛
    pram.game_num:决赛三局两胜的第几局
]]--
function GreatestRaceModel:__getMatchTitle(param)
    if param.front_stage == self.STAGE_PRE then
        return "预赛第" .. param.round .. "场"
    elseif param.front_stage == self.STAGE_EARLY then
        return "初赛第" .. param.round .. "场"
    elseif param.front_stage == self.STAGE_SEMI then
        return "复赛第" .. param.round .. "场"
    else
        -- 决赛：32=32强赛，16=16强赛，8=8强，4=4强，2-半决赛，1=决赛与季军赛
        if param.round == 32 then
            return "32强赛第" .. param.game_num .. "轮"
        elseif param.round == 16 then
            return "16强赛第" .. param.game_num .. "轮"
        elseif param.round == 8 then
            return "8强赛第" .. param.game_num .. "轮"
        elseif param.round == 4 then
            return "4强赛第" .. param.game_num .. "轮"
        elseif param.round == 2 then
            return "半决赛第" .. param.game_num .. "轮"
        elseif param.round == 1 and  param.vs_num == 1 then
            return "决赛第" .. param.game_num .. "轮"
        else
            return "季军赛第" .. param.game_num .. "轮"
        end
    end
end

function GreatestRaceModel:getRankByIndex(index)
    local data = self.rank_list[index]
    if data then
        local district = LoginModel:getDistrictById(data.server or "s1")
        data.server_name = "【" ..district.s_name .. " " .. district.name .. "】"
        data.is_my = (UserInfoModel.userInfoEntity.kid == data.kid and true or false)
        if self.current_stage == self.STAGE_FINAL then
            -- 如果是决赛，则改成第几名
            if data.rank == 1 then
                data.rank_title = "第一名"
            elseif data.rank == 2 then
                data.rank_title = "第二名"
            elseif data.rank == 3 then
                data.rank_title = "第三名"
            elseif data.rank == 4 then
                data.rank_title = "四强"
            elseif data.rank == 8 then
                data.rank_title = "八强"
            elseif data.rank == 16 then
                data.rank_title = "十六强"
            elseif data.rank == 32 then
                data.rank_title = "三十二强"
            else
                data.rank_title = "六十四强"
            end
        end
        return data
    else
        return nil
    end
end

function GreatestRaceModel:getRankNum()
    if self.rank_list and #self.rank_list > 0 then
        return #self.rank_list
    else
        return 0
    end
end

function GreatestRaceModel:getNextMacthTitle()
    if self.current_stage == self.STAGE_PRE then
        return "初赛"
    elseif self.current_stage == self.STAGE_EARLY then
        return "复赛"
    elseif self.current_stage == self.STAGE_SEMI then
        return "决赛"
    elseif self.current_stage == self.STAGE_FINAL then
        return "初赛"
    end
end

function GreatestRaceModel:getFinalTitle()
    local round = (self.data.global.round or 0)
    local vs_num = (self.data.vs_info.vs_num or 0)
    if round == 32 then
        return "32强赛"
    elseif round == 16 then
        return "16强赛"
    elseif round == 8 then
        return "8强赛"
    elseif round == 4 then
        return "4强赛"
    elseif round == 2 then
        return "半决赛"
    elseif round == 1 and vs_num == 1 then
        return "决赛"
    elseif round == 1 and vs_num == 2 then
        return "季军赛"
    else
        return ""
    end
end

function GreatestRaceModel:getCurrentId()
    return self.current_id
end

function GreatestRaceModel:getCurrentAction()
    return self.current_action
end

function GreatestRaceModel:getCurrentStatus()
    return self.current_status
end

function GreatestRaceModel:getCurrentStage()
    return self.current_stage
end

function GreatestRaceModel:setCurrentStatus(_status)
    self.current_status = _status
end

function GreatestRaceModel:getLevelForSignUp()
    return self.enter_level
end

function GreatestRaceModel:getLevelForSupport()
    return self.watch_level
end

function GreatestRaceModel:setShopSelectIndex(_idx)
    self.shopSelect = _idx
end

function GreatestRaceModel:getShopSelectIndex()
    return self.shopSelect or 1
end

function GreatestRaceModel:setSignUpStatus(data)
    if data.is_enter == 1 then
        self.is_sign_up = true
    else
        self.is_sign_up = false
    end
end

function GreatestRaceModel:isSignUp()
    return self.is_sign_up
end

-- 服务端报错没有返回正确数据时，加10分钟容错
function GreatestRaceModel:errorToUpdateTime()
    if self.data.global and self.data.global.next_time then
        self.data.global.next_time = UserInfoModel.serverTime + 10 * 30
    end
end

function GreatestRaceModel:getEndTime()
    if self.current_status == self.STATUS_MATCH then
        return self.data.global.next_play_time - UserInfoModel.serverTime
    else
        local time = self.data.global.next_time - UserInfoModel.serverTime
        if time == 0 then
            self.can_send_get = true
        end
        return time
    end
end

function GreatestRaceModel:getScoreTip()
    local data = qy.Config.strongest_battle_award
    local str = ""
    local num = 0
    if self.current_id == self.ID_MATCH then
        str = "获胜:      x"
    else
        str = "支持正确:      x"
        num = 10
    end

    if self.current_stage == self.STAGE_PRE then
        return str .. data[tostring(1+num)].arena_coin
    elseif self.current_stage == self.STAGE_EARLY then
        return str .. data[tostring(2+num)].arena_coin
    elseif self.current_stage == self.STAGE_SEMI then
        return str .. data[tostring(3+num)].arena_coin
    elseif self.data.global.round == 32 then
        return str .. data[tostring(4+num)].arena_coin
    elseif self.data.global.round == 16 then
        return str .. data[tostring(5+num)].arena_coin
    elseif self.data.global.round == 8 then
        return str .. data[tostring(6+num)].arena_coin
    elseif self.data.global.round == 4 then
        return str .. data[tostring(7+num)].arena_coin
    elseif self.data.vs_info.vs_num == 2 then
        return str .. data[tostring(8+num)].arena_coin
    else
        return str .. data[tostring(9+num)].arena_coin
    end
end

function GreatestRaceModel:calculateSupportNum(_source)
    if tonumber(_source) == nil or _source < 0 then
        _source = 0
    end
    local _target = 0
    if _source > 50 then
        _target = _target + (_source - 50) * 8
        _source = 50
    end
    if _source > 30 then
        _target = _target + (_source - 30) * 17
        _source = 30
    end
    if _source > 10 then
        _target = _target + (_source - 10) * 23
        _source = 10
    end

    _target = _target + _source * 12
    return _target
end

function GreatestRaceModel:addSupportByIndex(index)
    local num1 = 0
    local num2 = 0
    if self.data.vs_info then
        if index == 0 then
            num1 = (self.data.vs_info.att_support_num or 0) + 1
            num2 = (self.data.vs_info.def_support_num or 0)
        else
            num1 = (self.data.vs_info.att_support_num or 0)
            num2 = (self.data.vs_info.def_support_num or 0) + 1
        end
        self.data.vs_info.att_support_num = num1
        self.data.vs_info.def_support_num = num2
    end
    self:setSupportNum(num1,num2)
end

function GreatestRaceModel:setSupportNum(num1,num2)
    local support_num_1 = self:calculateSupportNum(num1)
    local support_num_2 = self:calculateSupportNum(num2)
    self.increase_support = {}
    self.increase_support[1] = math.floor((support_num_1 - self.support_num_arr[1])/self.update_match_time + 0.5)
    self.increase_support[2] = math.floor((support_num_2 - self.support_num_arr[2])/self.update_match_time + 0.5)
    if self.increase_support[1] < 0 then
        self.increase_support[1] = 0
    end
    if self.increase_support[2] < 0 then
        self.increase_support[2] = 0
    end
    self.support_num_arr = {support_num_1,support_num_2}
end

function GreatestRaceModel:getCombatParam()
    -- 阶段:stage:int:
    -- 轮次:round:int:
    -- 局数:game_num:int:
    -- 要查看的用户ID:log_kid:int:
    return {
        ["stage"] = self.data.global.stage,
        ["round"] = self.data.global.round,
        ["game_num"] = self.data.global.game_num,
        ["log_kid"] = self.data.vs_info.att_kid
    }
end

function GreatestRaceModel:getShowSupportNum(idx)
    local flag = false
    if self.current_stage == self.STAGE_FINAL then
        local data = self:getAttResults()
        if (data.win_times + data.fail_times) >= 1 then
            flag = true
        end
    end
    if self.ACTION_CALC == self.current_action or flag then
        -- 等待开赛阶段，支持人数不变，等于实际人数
        return self.support_num_arr[idx+1]
    else
        -- 不是等待开赛阶段，前端有速度的递增支持人数
        local num = self.show_support_arr[idx+1] + self.increase_support[idx+1]
        if num > self.support_num_arr[idx+1] then
            num = self.support_num_arr[idx+1]
        end
        self.show_support_arr[idx+1] = num
        return num
    end
end

function GreatestRaceModel:isLeftPriority()
    local flag = true
    if self.show_support_arr[1] == self.show_support_arr[2] then
        if self.data.vs_info then
            if self.data.vs_info.att_level >= self.data.vs_info.def_level then
                flag = true
            else
                flag = false
            end
        end
    elseif self.show_support_arr[1] > self.show_support_arr[2] then
        flag = true
    elseif self.show_support_arr[1] < self.show_support_arr[2] then
        flag = false
    end

    if self.current_stage == self.STAGE_FINAL then
        -- 决赛，如果上局是左方出手，这一局是右方出手
        local data = self:getAttResults()
        if (data.win_times + data.fail_times) == 1 then
            return not flag
        end
    end
    return flag
end

-- 比赛期间是否可以操作按钮
function GreatestRaceModel:canOperMatchBtn()
    if self:isSupported() or self:isCalculateBattle() or self:getCurrentAction() == self.ACTION_CALC then
        return false
    elseif self.current_id == self.ID_SUPPORT then
        local data = self:getAttResults()
        if (data.win_times + data.fail_times) >= 1 then
            return false
        end
    end
    return true
end

--后端计算战斗时间，现在暂定5分钟
function GreatestRaceModel:isCalculateBattle()
    local time = self.data.global.next_time - UserInfoModel.serverTime
    if time > 0 then
        return false
    else
        if self.current_stage ~= self.STAGE_FINAL and self.current_action ~= self.ACTION_GROUP and self.current_action ~= self.ACTION_WAIT then
            -- 决赛的分组时间，不更新状态
            self.current_action = self.ACTION_CALC
        end
        return true
    end
end

function GreatestRaceModel:initShopList()
    local data = qy.Config.strongest_battle_shop
    self.shop_list = {}
    for k, v in pairs(data) do
        self.shop_list[v.id] = v
    end
end

function GreatestRaceModel:getShopCellNum()
    return math.ceil(#self.shop_list/4)
end

function GreatestRaceModel:getShopListByIndex(index)
    return self.shop_list[index]
end

function GreatestRaceModel:getSignUpListByIdx(i)
    if self.data.list and self.data.list[i] then
        return self.data.list[i].nickname
    else
        return ""
    end
end

function GreatestRaceModel:getUserInfo(data)
    if data == nil then
        data = self.data
    end
    local server = "s1"
    if data.server then
        server = data.server
    end
    local arr = {}
    local district = LoginModel:getDistrictById(server or "s1")
    arr.server_name = "【" ..district.s_name .. " " .. district.name .. "】"
    arr.name = data.nickname or ""
    return arr
end

function GreatestRaceModel:initBattleData(data,showAward)
    BattleModel:clearAward()
    if showAward then
        if self.current_id == self.ID_MATCH then
            -- 参赛者
            if UserInfoModel.userInfoEntity.kid == data.log.att_kid then
                -- 进攻方
                BattleModel:initAward(data.log.att_award or {})
            elseif UserInfoModel.userInfoEntity.kid == data.log.def_kid then
                -- 防守方
                BattleModel:initAward(data.log.def_award or {})
            end
        else
            -- 观看者
            if data.arena_coin > 0 then
                local award = {["type"] = 30,["num"] = data.arena_coin}
                BattleModel:initAward({award})
            end
        end
    end
    self.bResultDes = {}
    if data.log.fight_result["end"].is_win == 1 then
        self.bResultDes.win_name = data.log.att_nickname
    else
        self.bResultDes.win_name = data.log.def_nickname
    end
    self.bResultDes.show_up = self:isFinalRound(data.log)
    if self:isFinalRound(data.log) then
        local is_final = true
        local _str = ""
        if data.log.stage == 2 then
            _str = "成功晋级初赛"
            is_final = false
        elseif data.log.stage == 4 then
            _str = "成功晋级复赛"
            is_final = false
        elseif data.log.stage == 6 then
            _str = "成功晋级决赛"
            is_final = false
        elseif data.log.round == 32 then
            _str = "成功晋级三十二强"
        elseif data.log.round == 16 then
            _str = "成功晋级十六强"
        elseif data.log.round == 8 then
            _str = "成功晋级八强"
        elseif data.log.round == 4 then
            _str = "成功晋级四强"
        elseif data.log.round == 2 then
            _str = "成功晋级半决赛"
        elseif data.log.vs_num == 1 then
            _str = "成为荣耀王者"
        elseif data.log.vs_num == 2 then
            _str = "获得第三名"
        end
        if not is_final then
            if data.log.att_is_up == 0 then
                self.bResultDes.up_des = data.log.att_nickname.."未获得晋级"
            elseif data.log.att_is_up == 1 then
                self.bResultDes.up_des = "恭喜"..data.log.att_nickname.._str
            end
        else
            if data.log.att_is_up == 1 then
                self.bResultDes.up_des = "恭喜"..data.log.att_nickname.._str
            elseif data.log.def_is_up == 1 then
                self.bResultDes.up_des = "恭喜"..data.log.def_nickname.._str
            end
        end
    else
        self.bResultDes.up_des = ""
    end
end

function GreatestRaceModel:getBResultDes()
    return self.bResultDes
end

--[[
    设置 get 接口 是否可以请求
    STATUS_MATCH 10s一次
    其他状态，仅是 倒计时完成时才请求
]]--

function GreatestRaceModel:setServiceStatus(_flag)
    if self.current_status == self.STATUS_MATCH then
        self.can_send_get = _flag
    end
end

function GreatestRaceModel:getServiceStatus()
    return self.can_send_get
end

---------------------------------------
function GreatestRaceModel:updateHistory(mon,data)
    self.history_arr = {}
    for i = 1, 4 do
        self.history_arr[i] = data[i]
        local district = LoginModel:getDistrictById(data[i].server or "s1")
        self.history_arr[i].server_title = "【" ..district.s_name .. " " .. district.name .. "】Lv." ..data[i].level
    end
    self.history_mon = mon
end

function GreatestRaceModel:getHistoryData()
    return self.history_arr
end

function GreatestRaceModel:getHistoryMon()
    return self.history_mon
end

function GreatestRaceModel:initLog(data)
    self.log_data = data.log
    self.log_user = self:getUserInfo(data)
end

function GreatestRaceModel:getLogUserInfo()
    return self.log_user
end

function GreatestRaceModel:getLogListByIndex(index)
    if self.log_data and self.log_data[index] then
        local data = self.log_data[index]
        data.front_stage = self:__getStage(data.stage)
        local title = self:__getMatchTitle(data)
        return {["title"] = title,["combat_id"] = data.combat_id,["id"] = data.id}
    else
        return nil
    end
end

function GreatestRaceModel:getLogNum()
    if self.log_data and #self.log_data then
        return #self.log_data
    else
        return 0
    end
end

function GreatestRaceModel:getErrorStatus()
    if self.viewUpdate then
        return true
    else
        return self.errorShow
    end
end

function GreatestRaceModel:setErrorStatus(flag)
    self.errorShow = flag
end

function GreatestRaceModel:getDelayTime()
    return 3
end

function GreatestRaceModel:getViewUpdateStatus()
    return self.viewUpdate
end

function GreatestRaceModel:setViewUpdateStatus(flag)
    self.viewUpdate = flag
end

return GreatestRaceModel
