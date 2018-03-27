--[[
    成就 升级属性预览表
    Author: mingming
    Date: 2015-08-21 16:28:15
]]

local CommentDialog = qy.class("CommentDialog", qy.tank.view.BaseView, "view/achievement/CommentDialog")

local model = qy.tank.model.AchievementModel
function CommentDialog:ctor(entity)
    CommentDialog.super.ctor(self)

    -- self:setCanceledOnTouchOutside(true)
    -- self:InjectView("Bg")
    -- self:InjectView("Title")
    self:InjectView("InputBg")
    

    -- -- 通用弹窗样式
    -- local style = qy.tank.view.style.DialogStyle3.new({
    --     size = cc.size(875, 540),   
    --     position = cc.p(0, 0),
    --     offset = cc.p(0, 0),
        
    --     ["onClose"] = function()
    --         self:dismiss()
    --     end
    -- })
    -- self:addChild(style)
    -- style:setLocalZOrder(-1)
    -- self.style = style

    local editBox = ccui.EditBox:create(cc.size(607, 25), ccui.Scale9Sprite:create())
    editBox:setAnchorPoint(0, 0)
    editBox:setPosition(5, 15)
    editBox:setFontSize(25)
    editBox:setPlaceHolder(qy.TextUtil:substitute(1010))
    editBox:setPlaceholderFontSize(30)
    editBox:setInputMode(6)
    editBox:setMaxLength(40)
    if editBox.setReturnType then
        editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    editBox:addTo(self.InputBg)

    self:OnClick("Btn_comment", function()
        --qy.QYPlaySound.stopMusic()
        local content = editBox:getText()
        if string.len(content) > 0 then
            qy.tank.service.AchievementService:addComment(entity.tank_id, content, function()
                editBox:setText("")
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(1011))
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    local winSize = cc.Director:getInstance():getWinSize()
    -- self.InputBg:setPositionX(winSize.width / 2 - 2)

    self.InputBg:addChild(self:createView(entity))

    self.enableService = true
end

function CommentDialog:createView(entity)
    local tableView = cc.TableView:create(cc.size(820, 380))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(-15, 80)

    local data = entity:getComment()

    local function numberOfCellsInTableView(tableView)
        return table.nums(data)
    end

    local function cellSizeForTable(tableView,idx)
        return 810, 105
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.achievement.CommentItem.new({
                ["onNice"] = function(sender)
                    qy.tank.service.AchievementService:addNice(sender.entity, function()
                        sender:update()
                        -- self.tableView:reloadData()
                    end)
                end
            })
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(data[idx + 1], idx)

        local offset = tableView:getContentOffset()
        
        self.idx = idx
        if (idx == table.nums(data) - 1 and self.enableService) and model.nextPage ~= -1 then
            self.enableService = false
            qy.tank.service.AchievementService:getCommentList(entity.tank_id, function()
                self.tableView:reloadData()
                self.tableView:setContentOffset(cc.p(0, self.idx * -79), false)
                self.enableService = true
            end, model.nextPage)
        end

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    -- tableView:registerScriptHandler(tableScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
    
    tableView:reloadData()
    self.tableView = tableView

    return tableView
end

return CommentDialog


