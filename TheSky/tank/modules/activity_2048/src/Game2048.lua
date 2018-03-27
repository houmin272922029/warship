--[[--
--2048
--Author: Fu.Qiang
--Date: 2016-07-04
--]]--


local Game2048 = qy.class("Game_2048", qy.tank.view.BaseView)

local model = qy.tank.model.FanFanLeModel
local service = qy.tank.service.FanFanLeService
local userinfoModel = qy.tank.model.UserInfoModel

local direction_top = 1
local direction_right = 2
local direction_bottom = 3
local direction_left = 4



--file 图片路径  "../../number_"   
--size 图片长宽
--space 间距
--max_num 可以合成的最大数 （（ 没写 ））
--num_table number数组，当合成这几个数时调用num_callback
--lose_back 失败调用函数

--应该改成只传delegate， 其他参数由delegate点出来

function Game2048:ctor(delegate, file, size, space, max_num, lose_back, num_table, num_callback, update_callback)
    Game2048.super.ctor(self)

    self.num_pos = {}
    self.num_sprite_pos = {}
    self.num_list = {}
    self.num_action_list = {}

    self.space = space
    self.delegate = delegate
    self.file = file
    self.lose_back = lose_back
    self.num_table = num_table
    self.num_callback = num_callback
    self.update_callback = update_callback
    self.isPause = false
    self.hammer_model = false
    self.speed = 0.1
    self.award_action = false
    self.game_over = false
    self.award_table = {}

    if type(size) == "table" then
        self.img_width = size.width
        self.img_height = size.height
    elseif type(size) == "number" then
        self.img_width = size
        self.img_height = size
    end
    self.last_touch_direction = direction_bottom -- 1234：上右下左    


    self.bg = ccui.ImageView:create()
    self.bg:loadTexture("Resources/common/bg/c12.png",2)
    self.bg:setName("bg")
    self.bg:setLocalZOrder(1)
    self.bg:setScale9Enabled(true)
    self.bg:setContentSize(cc.size(self.img_width * 4 + space * 3, self.img_height * 4 + space * 3))
    self:addChild(self.bg, 1)
    
    
end



function Game2048:onEnter()
    
    self:addTouch()
    
end


function Game2048:onExit()
    self:removeTouch()
end



function Game2048:addTouch()
    print("_____________________")
    self.listener = cc.EventListenerTouchOneByOne:create()
    local function onTouchBegan(touch, event)
        self.touch_begin = touch:getLocation()
        self.touch_flag = true
        return true
    end

    local function onTouchMoved(touch, event)
        print("self.isPause", self.isPause)
        if not self.isPause then 
            local touchPoint = touch:getLocation()

            if (math.abs(touchPoint.x - self.touch_begin.x) > 20 or math.abs(touchPoint.y - self.touch_begin.y) > 20) and self.touch_flag then
                local pos = cc.p(touchPoint.x - self.touch_begin.x, touchPoint.y - self.touch_begin.y)
                if math.abs(pos.x) > math.abs(pos.y) then
                    if pos.x > 0 then
                        self.last_touch_direction = direction_right
                    else
                        self.last_touch_direction = direction_left
                    end
                else
                    if pos.y > 0 then
                        self.last_touch_direction = direction_top
                    else
                        self.last_touch_direction = direction_bottom
                    end
                end
                self.touch_flag = false
                self:touch(self.last_touch_direction)
            end
        end
    end

    local function onTouchEnded(touch, event)
        self.touch_end = self.bg:convertToNodeSpace(touch:getLocation())
        print("touch_end", self.touch_end.x)
        print("touch_end", self.touch_end.y)

        if self.hammer_model and self.touch_end.x > 0 and self.touch_end.x < self.bg:getContentSize().width then            
            self:removeNum(self.touch_end, self.hammer_callback)
        end
    end

    self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    self.eventDispatcher = self:getEventDispatcher()
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener,self.bg)

end


function Game2048:removeTouch()
    print("+++++++++++++++++++++")
    if self.listener then
        self.eventDispatcher:removeEventListener(self.listener)
        self.listener = nil
    end
end


function Game2048:pauseGame()
    --self.eventDispatcher:pauseEventListenersForTarget(self.bg)
    self.isPause = true
end


function Game2048:resumeGame()
    --self.eventDispatcher:resumeEventListenersForTarget(self.bg)
    self.isPause = false
end

function Game2048:isPauseGame()

    return self.isPause
end


function Game2048:openHammerModel(callback)
    if not self.hammer_model then
        self:pauseGame()
        self.hammer_model = true
        self.hammer_callback = callback

        return true
    end

    return false
end


function Game2048:stopHammerModel()
    if self.hammer_model then
        self:resumeGame()
        self.hammer_model = false
        self.hammer_callback = nil
    end
end

function Game2048:isHammerModel()
    return self.hammer_model
end


function Game2048:removeNum(pos, callback)
    if type(pos) == "number" then


    else
        --local _pos = ((math.floor(pos.y / (self.img_width + self.space) - 0.01) + 1) - 1) * 4 + math.floor(pos.x / (self.img_width + self.space) - 0.01) + 1
        local _pos = ((math.floor(self.touch_end.y / (self.img_width + self.space) - 0.01) + 1) - 1) * 4 + math.floor(self.touch_end.x / (self.img_width + self.space) - 0.01) + 1

        print(_pos, "_pos")

        if self:getValue(self.num_list, _pos, 0) == 0 then
            return false
        end


        self:setValue(self.num_list, _pos, 0)

        num_sprite = self.bg:getChildByName(tostring(_pos))
        num_sprite:runAction(cc.Sequence:create(cc.DelayTime:create(0.7), cc.FadeTo:create(0.3, 0), cc.CallFunc:create(function()
            num_sprite:setVisible(false)
            num_sprite:setOpacity(255)
        end)))

        if type(callback) == "function" then
            callback(self:getValue(self.num_sprite_pos, _pos))
        end

        return true
    end

    return false
end



--初始化
function Game2048:initGame(num_list)
    self.game_over = false
    self.isPause = false
    --从左下到右上
    for y = 1, 4 do
        if self.num_sprite_pos[tostring(y)] == nil then
            self.num_sprite_pos[tostring(y)] = {}
            self.num_list[tostring(y)] = {}
            self.num_pos[tostring(y)] = {}
            self.num_action_list[tostring(y)] = {}     
        end
        for x = 1, 4 do            
            self.num_sprite_pos[tostring(y)][tostring(x)] = cc.p(self.img_width / 2 + (self.img_width + self.space) * (x - 1), self.img_width / 2 + (self.img_width + self.space) * (y - 1))
            self.num_list[tostring(y)][tostring(x)] = 0
            self.num_pos[tostring(y)][tostring(x)] = (y - 1) * 4 + x
            self.num_action_list[tostring(y)][tostring(x)] = {["type"] = nil, ["move_to"] = 0} --move, update,  move_to 1~16为移动到的位置   
        end
    end

    if type(num_list) == "table" and num_list["1"] then
        self.num_list = num_list
        self:updateAllSprites()
    else
        self.bg:removeAllChildren()
        self:addNumSprite()
        self:addNumSprite()
    end    
end



function Game2048:gameOver()
    self.game_over = true
end

function Game2048:touch(direction)
    local __num_list = {}
    local __num_pos = {}
    local __num_action_list = {}

    -- 第一次旋转矩阵
    __num_pos = self:updateMatrix(__num_pos, self.num_pos, direction)
    __num_list = self:updateMatrix(__num_list, self.num_list, direction)
    __num_action_list = self:updateMatrix(__num_action_list, self.num_action_list, direction)

   
    local flag = false
    __num_list, __num_action_list, flag = self:mergeNum(__num_list, __num_action_list, __num_pos)


    if direction == 1 then
        direction = 1
    elseif direction == 2 then
        direction = 4
    elseif direction == 4 then
        direction = 2
    end

    -- 第二次，反转 
    self.num_pos = self:updateMatrix(self.num_pos, __num_pos, direction)
    self.num_list = self:updateMatrix(self.num_list, __num_list, direction)
    self.num_action_list = self:updateMatrix(self.num_action_list, __num_action_list, direction)

    
    if flag then

        self:updateAllSprites()

        if #self.award_table > 0 then
            self.num_callback(self.award_table)
            self.award_table = {}
        end
      
        --                                                    添加速度需同步或更后
        self:runAction(cc.Sequence:create(cc.DelayTime:create(self.speed), cc.CallFunc:create(function()
            self:addNumSprite()
            self.update_callback()

            if self:judgeLose() then
                qy.hint:show(qy.TextUtil:substitute(90258))
                self:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(function()
                    if type(self.lose_back) == "function" then
                        self.lose_back()
                    else
                        self:initGame()
                    end
                end)))
            end
        end)))
    end


end


function Game2048:updateAllSprites()
    for y = 1, 4 do
        for x = 1, 4 do            
            local pos = (y - 1) * 4 + x      
            self:updateSprite(pos)
        end
    end
end


function Game2048:updateSprite(pos)

    local num_sprite = self.bg:getChildByName(tostring(pos))
    if not num_sprite then
        num_sprite = ccui.ImageView:create()
        num_sprite:setName(tostring(pos))
        num_sprite:setPosition(self:getValue(self.num_sprite_pos, pos))
        self.bg:addChild(num_sprite, 1)
    end

    if self:getValue(self.num_action_list, pos).type == "move" then
        local move_to = pos
        while self:getValue(self.num_action_list, move_to).move_to > 0 do
            local num = move_to
            move_to = self:getValue(self.num_action_list, num).move_to
            self:setValue(self.num_action_list, num, {["type"] = nil, ["move_to"] = 0})
        end
        self:setValue(self.num_action_list, pos, {["type"] = nil, ["move_to"] = 0})

        num_sprite:runAction(cc.Sequence:create(cc.MoveTo:create(self.speed, self:getValue(self.num_sprite_pos, move_to)), cc.CallFunc:create(function()
            num_sprite:setPosition(self:getValue(self.num_sprite_pos, pos))
            num_sprite:setVisible(false)
        end)))       

    elseif self:getValue(self.num_action_list, pos).type == "update" then
        
        num_sprite:runAction(cc.Sequence:create(cc.DelayTime:create(self.speed), cc.CallFunc:create(function()
            num_sprite:loadTexture(self.file..tostring(self:getValue(self.num_list, pos))..".png",0)
            num_sprite:setVisible(true)
            self:setValue(self.num_action_list, pos, {["type"] = nil, ["move_to"] = 0})                
        end)))

    elseif self:getValue(self.num_action_list, pos).type == nil and self:getValue(self.num_list, pos, 0) > 0 then
        num_sprite:loadTexture(self.file..tostring(self:getValue(self.num_list, pos))..".png",0)
        num_sprite:setVisible(true)
    end
end


--根据方向变换矩阵
function Game2048:updateMatrix(table1, table2, direction)
    if direction == direction_bottom then
        table1 = table2
    elseif direction == direction_left then
        for y = 1, 4 do
            for x = 1, 4 do
                self:setValue(table1, (y - 1) * 4 + x, self:getValue(table2, (4 - x) * 4 + y))
            end
        end
    elseif direction == direction_top then
        for y = 1, 4 do
            for x = 1, 4 do
                self:setValue(table1, (y - 1) * 4 + x, self:getValue(table2, (4 - y) * 4 + 5 - x))
            end
        end

    elseif direction == direction_right then
        for y = 1, 4 do
            for x = 1, 4 do
                self:setValue(table1, (y - 1) * 4 + x, self:getValue(table2, x * 4 - (y - 1)))
            end
        end
    end

    return table1
end


--合并数字
function Game2048:mergeNum(__num_list, __num_action_list, __num_pos)
    local flag = false
    for x = 1, 4 do
        --从y = 1开始， 如果x, y上的num_list值为0， 则循环上面，获得第一个不为0的位置与其互换
        if  self:getValue(__num_list, 0 + x, 0) + 
            self:getValue(__num_list, 4 + x, 0) + 
            self:getValue(__num_list, 8 + x, 0) + 
            self:getValue(__num_list, 12 + x, 0) > 0 then
            for y1 = 1, 3 do
                local _break = true
                while _break do

                    if self:getValue(__num_list, (y1 - 1) * 4 + x, 0) == 0 then
                        local result = 0
                        for y2 = y1 + 1, 4 do 
                            result = result + self:getValue(__num_list, (y2 - 1) * 4 + x, 0)
                        end

                        if result == 0 then
                            _break = false
                        end

                        for y2 = y1 + 1, 4 do 
                            if self:getValue(__num_list, (y2 - 1) * 4 + x, 0) ~= 0 then       

                                self:setValue(__num_list, (y1 - 1) * 4 + x, self:getValue(__num_list, (y2 - 1) * 4 + x, 0))
                                self:setValue(__num_list, (y2 - 1) * 4 + x, 0)

                                self:setValue(__num_action_list, (y2 - 1) * 4 + x, {["type"] = "move", ["move_to"] = self:getValue(__num_pos, (y1 - 1) * 4 + x)})
                                self:setValue(__num_action_list, (y1 - 1) * 4 + x, {["type"] = "update", ["move_to"] = 0})

                                flag = true
                                break  
                            end 
                        end
                    else
                        for y2 = y1 + 1, 4 do 
                            if self:getValue(__num_list, (y2 - 1) * 4 + x, 0) ~= 0 then 
                                if self:getValue(__num_list, (y1 - 1) * 4 + x, 0) == self:getValue(__num_list, (y2 - 1) * 4 + x, 0) then 
                                    --动画第一次指向
                                    local sum = self:getValue(__num_list, (y1 - 1) * 4 + x, 0) + self:getValue(__num_list, (y2 - 1) * 4 + x, 0)

                                    self:setValue(__num_list, (y1 - 1) * 4 + x, sum)
                                    self:setValue(__num_list, (y2 - 1) * 4 + x, 0)

                                    self:setValue(__num_action_list, (y2 - 1) * 4 + x, {["type"] = "move", ["move_to"] = self:getValue(__num_pos, (y1 - 1) * 4 + x)})
                                    self:setValue(__num_action_list, (y1 - 1) * 4 + x, {["type"] = "update", ["move_to"] = 0})

                                    print("#self.num_table", #self.num_table)

                                    for i = 1, #self.num_table do
                                        if self.num_table[i] == sum then
                                            print("sum", sum)
                                            table.insert(self.award_table, sum)
                                        end
                                    end

                                    flag = true                        
                                end
                                break
                            end
                        end
                        _break = false
                    end
                end
            end
        end
    end
   
    return __num_list, __num_action_list, flag
end


--根据上次滑动方向  添加一个新数字
function Game2048:addNumSprite()
    local list = self:getEmptyPos(self.last_touch_direction)
    local pos = 0

    if #list == 0 then
        --输了
    elseif #list > 1 then
        pos = math.floor(#list / 2)
    else 
        pos = 1
    end
    pos = list[math.random(1, pos)]
    local num = math.random(1, 7) == 7 and 4 or 2

    local num_sprite = self.bg:getChildByName(tostring(pos))
    if not num_sprite then
        num_sprite = ccui.ImageView:create()        
        num_sprite:setName(tostring(pos))
        num_sprite:setPosition(self:getValue(self.num_sprite_pos, pos))
        self.bg:addChild(num_sprite, 1)
    end
    num_sprite:loadTexture(self.file..num..".png",0)
    num_sprite:setVisible(true)


    self:setValue(self.num_list, pos, num)

    return num
end


--根据上次滑动方 用不同顺序遍历所有格子 将空位下标集合返回
function Game2048:getEmptyPos(direction_type)
    local num = 0
    local list = {}
    for i = 1, 17 do
        local result
        if direction_type == direction_bottom then
            if num == 0 then
                num = 13
            elseif num % 4 == 0 then
                if num == 4 then
                    return list
                end
                num = num - 7
            else
                num = num + 1
            end            
        elseif direction_type == direction_left then
            if num == 0 then
                num = 16
            elseif num <= 4 and num >= 2 then
                num = num + 12 - 1
            elseif num == 1 then
                return list
            else
                num = num - 4
            end
        elseif direction_type == direction_top then
            if num == 0 then
                num = 1
            elseif num == 16 then
                return list
            else
                num = num + 1
            end
        elseif direction_type == direction_right then
            if num == 0 then
                num = 1
            elseif num >= 13 and num < 16 then
                num = num - 11
            elseif num == 16 then
                return list
            else
                num = num + 4
            end
        else
            --没有默认左
            if num == 0 then
                num = 1
            elseif num % 4 == 0 then
                if num == 16 then
                    return list
                end
                num = num + 1
            end
        end
        result = self:isEmpty(num)
        if result ~= -1 then
            table.insert(list, result)
        end
    end
end

--判断这个位置是否是空位
function Game2048:isEmpty(pos)
    --if self:getValue(self.num_list, pos, 0) == 0 and self:getValue(self.num_sprite_list, pos) == nil then
    --if self:getValue(self.num_list, pos, 0) == 0 and (self.bg:getChildByName(tostring(pos)) == nil or self.bg:getChildByName(tostring(pos)):isVisible() == false) then
    if self:getValue(self.num_list, pos, 0) == 0 then
        return pos
    else
        return -1
    end
end


function Game2048:getValue(table, pos, default)
    if table and pos then
        local result = table[tostring(math.floor((pos - 1) / 4) + 1)][tostring(math.floor((pos - 1) % 4) + 1)]
        if result == nil and default ~= nil then
            return default
        end
        return result
    elseif default ~= nil then
        return default
    end
    return nil
end

function Game2048:setValue(table, pos, value)
    if table[tostring(math.floor((pos - 1) / 4) + 1)] == nil then
        table[tostring(math.floor((pos - 1) / 4) + 1)] = {}
    end
    table[tostring(math.floor((pos - 1) / 4) + 1)][tostring(math.floor((pos - 1) % 4) + 1)] = value
    return value
end

function Game2048:judgeLose()
    for i = 1, 16 do
        local pos1 = i % 4 == 0 and 0 or i + 1 --右
        local pos2 = i + 4 --上

        if self:getValue(self.num_list, i) == 0 then
            return false
        end

        if pos1 > 1 and pos1 <= 16 and self:getValue(self.num_list, i) == self:getValue(self.num_list, pos1) then
            return false
        end

        if pos2 > 1 and pos2 <= 16 and self:getValue(self.num_list, i) == self:getValue(self.num_list, pos2) then
            return false
        end
    end

    return true
end

function Game2048:getScore()
    local score = 0
    for i = 1, 16 do 
        score = score + self:getValue(self.num_list, i, 0)
    end

    return score
end

function Game2048:getNumList()
    return self.num_list 
end



return Game2048