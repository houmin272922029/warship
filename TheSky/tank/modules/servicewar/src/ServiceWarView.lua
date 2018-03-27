--[[
	跨服战首页

]]
local ServiceWarView = qy.class("ServiceWarView", qy.tank.view.BaseView, "servicewar.ui.ServiceWarView")

local model = qy.tank.model.ServiceWarModel
local userModel = qy.tank.model.UserInfoModel
local amodel = qy.tank.model.ArenaModel

function ServiceWarView:ctor(delegate)
  ServiceWarView.super.ctor(self)
	
  local winSize = cc.Director:getInstance():getWinSize()
	self:InjectView("Button_2")
	self:InjectView("btn1")
	self:InjectView("Button_4")
	self:InjectView("callback")
	-- self:InjectView("name1")
	-- self:InjectView("name2")
	-- self:InjectView("name3")
  self:InjectView("ranklist")
	self:InjectView("start_image")
  self:InjectView("rank1")
  self:InjectView("rank2")
  self:InjectView("rank3")
  self:InjectView("rank")
  self:InjectView("rank4")
  self:InjectView("never")
  self:InjectView("award")
  self:InjectView("awards")
  self:InjectView("support")
  self:InjectView("Text_2")
  self:InjectView("score")
  self:InjectView("reward_btn")
  self:InjectView("time")
  self:InjectView("Image_1")
  self:InjectView("myrank")
  self:InjectView("reward")
  self:InjectView("zhichi")
  self:InjectView("play")
  self:InjectView("ranks")
  self:InjectView("ranks_0")
  self:InjectView("nums")
  self:InjectView("player_name")
  self:InjectView("Sprite_1")
  self:InjectView("compare")
  self:InjectView("zhangong")
  self:InjectView("change")
  -- self:InjectView("Line1")
  -- self:InjectView("Line2")
  -- self:InjectView("Line3")
  self:InjectView("titles")
  -- self:InjectView("Image_14")
  self:InjectView("enter")
  self:InjectView("enter1")
  -- self:InjectView("Image_13")
  self:InjectView("enter2")
  -- self:InjectView("Image_12")

  self.delegate = delegate

	local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "servicewar/res/dianfengduijue.png",
        showHome = true,
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style)
    
    self:OnClick("btn1", function(sender)
    	qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.ARENA)
    end)

    self:OnClick("Button_2", function(sender)
    	qy.tank.view.common.HelpDialog.new(22):show(true)
    end,{["isScale"] = false})
   
      
      self:OnClick("start_image", function(sender)
       if (model.role == 200 and model.isBet == 100) and (model.betinfo and model.betinfo.bet_status == 200) then
          qy.hint:show(qy.TextUtil:substitute(90066))
        else
          delegate.showWar()
          
        end

      end,{["isScale"] = false})
    

   	self:OnClick("Button_4", function(sender)
   		local service = qy.tank.service.ServiceWarService
            service:ShopList(function(data)
              -- qy.tank.modules.servicewar.src.ServiceWarShop.new
              require("servicewar.src.ServiceWarShop").new(
              {
                ["data"] = data
              }):show(true)
      end)
    end)

    self:OnClick("reward_btn", function(sender)
      if model.role == 200 then
        if model.isBet == 100 then
          if model.betinfo.bet_status == 300 then
              qy.hint:show(qy.TextUtil:substitute(90067))
          elseif model.betinfo.bet_status == 200 then
              local service = qy.tank.service.ServiceWarService
                  service:GetAwards(function(data)
                    qy.hint:show(qy.TextUtil:substitute(90068))
                    self.reward_btn:setBright(false)
              end)
          else
              qy.hint:show(qy.TextUtil:substitute(90070))
          end
        elseif model.isBet == 200 then
            qy.hint:show(qy.TextUtil:substitute(90069))
        else
            qy.hint:show(qy.TextUtil:substitute(90071))
        end
      else
        self.reward_btn:setBright(false)
        qy.hint:show(qy.TextUtil:substitute(90072))
      end
      
    end)

    -- self:OnClick("name1", function (sender)
    --   if model.service_user_list then
    --     qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE, model.service_user_list["1"].kid, 1)
    --   end
    -- end)

    -- self:OnClick("name2", function (sender)
    --   if model.service_user_list then
    --     qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE, model.service_user_list["2"].kid, 1)
    --   end
    -- end)

    -- self:OnClick("name3", function (sender)
    --   if model.service_user_list then
    --    qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE, model.service_user_list["3"].kid, 1)
    --   end
    -- end)

    self:ShowDetail()
  end

function ServiceWarView:playMessageAnimation(node)
    if node:getNumberOfRunningActions() == 0 then
        local func1 = cc.FadeTo:create(1, 210)
        local func2 = cc.FadeTo:create(1, 255)
        local func3 = cc.ScaleTo:create(1, 1.2)
        local func4 = cc.ScaleTo:create(1, 1)
        local func5 = cc.DelayTime:create(0.5)

        node:runAction(cc.RepeatForever:create(cc.Sequence:create(func1, func2, func5)))
        node:runAction(cc.RepeatForever:create(cc.Sequence:create(func4, func3, func5)))
    end
end

function ServiceWarView:ShowDetail()
    self.ranks_0:setVisible(false)
    self.never:setVisible(model.role == 200)
    self.Text_2:setVisible(model.role == 100)
    self.nums:setVisible(model.role ~= 100 )
    self.nums:setPositionX(155.5)
    self.zhangong:setVisible(model.role == 100)

    if model.role == 100 then
      self.myrank:setString(model.myrank)
      self.zhangong:setVisible(true)
      -- self.reward:setTextColor(cc.c4b(100, 95, 96, 0))
      if model.myrewards then
       self.reward:setString("x" .. model.myrewards)
     end
      if model.mysupports == 0 then
          self.zhichi:setString(qy.TextUtil:substitute(90073))
      else
        self.zhichi:setString(model.mysupports)
      end
      self.score:setVisible(false)
      self.awards:setVisible(false)
      self.time:setVisible(false)
      self.reward_btn:setVisible(false)
      self.Image_1:setVisible(false)
      self.rank4:setVisible(false)
      self.play:setVisible(false)
      self.ranks:setVisible(false)
      self.change:setVisible(false)
      self.player_name:setVisible(false)
      if model.myrank < model.pastrank then 
        self.myrank:setString(model.pastrank .. " → " .. model.myrank)
        self.compare:setString("(" .. "+" .. model.pastrank - model.myrank .. qy.TextUtil:substitute(90074).. ")")
        self.compare:setTextColor(cc.c4b(255, 0, 0, 255))
      elseif model.myrank == model.pastrank then
        self.myrank:setString(model.pastrank .. " → " .. model.myrank)
        self.compare:setString("")
      else
        self.myrank:setString(model.pastrank .. " → " .. model.myrank)
        self.compare:setString("(" .. model.pastrank - model.myrank .. qy.TextUtil:substitute(90074) .. ")")
        self.compare:setTextColor(cc.c4b(0, 255, 0, 255))

      end
    elseif model.role == 200 then
      self.myrank:setString("")
      self.reward:setString("")
      self.zhichi:setString("")
      self.compare:setString("")
      if model.isBet == 100 then --押注
        self.rank:setVisible(false)
        self.award:setVisible(false)
        self.support:setVisible(false)
        self.play:setString("【" .. model.betinfo.serviceid .. "】")
        self.play:setVisible(true)
        self.player_name:setString(model.betinfo.nickname)
        self.ranks:setString(model.betinfo.ranking)
        if model.currentrank and model.pastrank then
          if model.currentrank < model.pastrank then
            self.ranks:setString(model.pastrank .. " → " .. model.currentrank)
            self.change:setVisible(true)
            self.change:setString("(" .. "+" .. model.pastrank  - model.currentrank .. qy.TextUtil:substitute(90074).. ")")
            self.change:setTextColor(cc.c4b(255, 0, 0, 255))
          elseif model.pastrank == model.currentrank then
            self.ranks:setString(model.pastrank .. " → " .. model.currentrank)
            self.change:setString("")
          else
            self.ranks:setString(model.pastrank .. " → " .. model.currentrank)
            self.change:setVisible(true)
            self.change:setString("(" .. model.pastrank - model.currentrank .. qy.TextUtil:substitute(90074) .. ")")
            self.change:setTextColor(cc.c4b(0, 255, 0, 255))
          end
        end
        self.nums:setString(model.betinfo.bet_reward * qy.tank.model.UserInfoModel.userInfoEntity.level)
        -- self.time:setVisible(false)
        self.Image_1:setVisible(true)
        self.reward_btn:setBright(true)
        self.player_name:setVisible(true)
        self.ranks:setVisible(true)
        self.nums:setVisible(true)
        if model.betinfo.bet_status == 300 then
          self.reward_btn:setBright(false)
          self.time:setVisible(true)
          self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.endtime - qy.tank.model.UserInfoModel.serverTime))
          
        elseif model.betinfo.bet_status == 200 then
          self.time:setVisible(false)
          -- self:OnClick("reward_btn", function(sender)
              
          -- end)

        end
      elseif model.isBet == 200 then  --未押注
        self.rank:setVisible(false)
        self.award:setVisible(false)
        self.support:setVisible(false)
        self.player_name:setVisible(false)
        self.play:setVisible(false)
        self.ranks_0:setVisible(true)
        self.ranks_0:setString(qy.TextUtil:substitute(90075))
        self.ranks:setString(qy.TextUtil:substitute(90075))
        self.nums:setString(qy.TextUtil:substitute(90075))
        self.nums:setPositionX(119)
        self.reward_btn:setVisible(true)
        self.Image_1:setVisible(false)
        self.reward_btn:setBright(false)
        self.time:setVisible(false)
        self.zhangong:setVisible(false)
        self.change:setVisible(false)
        -- self:OnClick("reward_btn", function(sender)
        --     qy.hint:show("无法领取奖励，请进入跨服战场进行押注")
        --   end)
      end

    end
end

-- function ServiceWarView:refershBet()
--   if model.sername and model.nickname and model.ranking and model.bet_reward and model.endtime then
--       self.play:setString("【" .. model.sername .. " 】")
--       self.play:setVisible(true)
--       self.player_name:setString(model.nickname)
--       self.ranks:setString(model.ranking)
--       self.nums:setString(model.bet_reward * qy.tank.model.UserInfoModel.userInfoEntity.level)
--       self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.endtime - qy.tank.model.UserInfoModel.serverTime, 6))
--   end
-- end

function  ServiceWarView:onEnter()
  for i = 1, 3 do
    if not model.service_user_list or not model.service_user_list[tostring(i)] then
       -- self['Line' .. i]:setVisible(false)
       self.titles:setVisible(true)
    else
       -- self['Line' .. i]:setVisible(true)
       self.titles:setVisible(false)
    end
  end
  -- self.Line1:setVisible(model.service_user_list and model.service_user_list["1"])
  -- self.Line2:setVisible(model.service_user_list and model.service_user_list["2"])
  -- self.Line3:setVisible(model.service_user_list and model.service_user_list["3"])
  -- if model.service_user_list then
  --   self.name1:setString(model.service_user_list["1"] and model.service_user_list["1"].nickname or "")
  --   self.name2:setString(model.service_user_list["2"] and model.service_user_list["2"].nickname or "")
  --   self.name3:setString(model.service_user_list["3"] and model.service_user_list["3"].nickname or "")
  -- end
  if model.service_user_list then
    self.ranklist:removeAllChildren(true)
    self.ranklist:addChild(self:createrank())
  end

  local xx = table.nums(model.service_user_list)

  if not model.service_user_list or not model.service_user_list["1"] then
    self.titles:setVisible(false)
    -- self.Image_12:setVisible(false)
    if xx == 0 then
        self.enter2:setString(qy.TextUtil:substitute(90076))
    end
  end

  if not model.service_user_list or not model.service_user_list["2"] then
    self.titles:setVisible(false)
    -- self.Image_13:setVisible(false)
    if xx <= 1 then
      self.enter1:setString(qy.TextUtil:substitute(90076))
    end
  end

  if not model.service_user_list or not model.service_user_list["3"]then
    -- self.Image_14:setVisible(false)
    self.titles:setVisible(false)
    if xx <= 2 then
        self.enter:setString(qy.TextUtil:substitute(90076))
    end
  end

  self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
    self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.endtime - qy.tank.model.UserInfoModel.serverTime, 6))
  end)

  -- self.listener_2 = qy.Event.add(qy.Event.SERVICE_WARVIEW,function(event)
  --   print("********====")
  --       self:refershBet()
  --   end)
  self:playMessageAnimation(self.Sprite_1)
  self:ShowDetail()
  -- self:refershBet()
end
function ServiceWarView:createrank( )
    local tableView = cc.TableView:create(cc.size(420, 180))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(10, 5)
    tableView:setDelegate()
    local list = {}
    for k,v in pairs(model.service_user_list) do
        table.insert(list,v)
    end
    table.sort(list, function(a, b)
        return a.rank < b.rank
    end)
    local function numberOfCellsInTableView(tableView)
        return #list
    end
    
    local function cellSizeForTable(tableView, idx)
        return 420, 55
    end
    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("servicewar.src.RankCellNew").new({
              ["data"] = list
              })
            cell:addChild(item)
            cell.item = item
        end
        cell.item.idx = idx
        cell.item:setData(idx + 1)
        return cell
    end
    tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end

function ServiceWarView:onExit()
  qy.Event.remove(self.listener_1)
  -- qy.Event.remove(self.listener_2)
end

return ServiceWarView