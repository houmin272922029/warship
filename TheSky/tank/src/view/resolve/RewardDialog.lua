--[[
--图鉴
--Author: mingming
--Date:
]]

local RewardDialog = qy.class("RewardDialog", qy.tank.view.BaseDialog, "view/resolve/RewardDialog")

function RewardDialog:ctor(delegate)
    RewardDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
     self.model = qy.tank.model.ResolveModel

    local style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(494, 340),
        position = cc.p(0,0),
        offset = cc.p(0,0),

        -- ["onClose"] = function()
        --     self:dismiss()
        -- end
    })
    self:addChild(style, -1)

    self:InjectView("Image_1")

    self:OnClick("Btn_cancel", function()
        --qy.QYPlaySound.stopMusic()
        self:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_verify", function()
        --qy.QYPlaySound.stopMusic()
        delegate.resolve(function()
            self:dismiss()
        end)
    end,{["audioType"] = qy.SoundType.SALE, ["isScale"] = false})

    -- for i = 1, 3 do
    --     local item = qy.tank.view.common.ItemIcon.new()
    --     item:setPosition(80 + 150 * (i - 1) , 100)
    --     self.Image_1:addChild(item)
    --     self["item" .. i] = item
    -- end

    -- local z = 1
    -- for i, v in pairs(delegate) do
    --     self["item" .. z]:setData(v)
    --     z = z + 1
    -- end
    local _vipLevel = qy.tank.model.UserInfoModel.userInfoEntity.vipLevel--vip等级
    local shu = self.model:GetVip(_vipLevel)
    local shujuxx = self.model:getJiChu()
    for k,v in pairs(shujuxx) do
        if #shu ~= 0 then
            local maxOfT = math.max(unpack(shu))
            for i=1,#delegate.data do
                -- print("分解浮点数888",maxOfT/1000)
                -- print("分解浮点数===",delegate.data[i].num)
                -- local t1,t2
                -- t1,t2 = math.modf(delegate.data[i].num * ((maxOfT/1000)+1))
                -- print("oooooooooo",t1)
                -- print("oooooooooo",t2)
                -- if t2 > 0 then
                --     t1 = t1 + 1
                -- end
                -- print("pppppppppppppp",delegate.data[i].type)

                if tonumber(delegate.data[i].type) == tonumber(k) then
                    print("cc11111",delegate.data[i].num)
                    delegate.data[i].num = math.ceil(delegate.data[i].num + v.num * maxOfT/1000)
                    print("cc2222222",delegate.data[i].num)
                else
                    delegate.data[i].num = delegate.data[i].num + 0
                end
                
                -- print("分解浮点数----",delegate.data[i].num * ((maxOfT/1000)+1))
                --delegate.data[i].num = math.ceil(delegate.data[i].num * ((maxOfT/1000)+1))
                -- print("分解浮点数",delegate.data[i].num)

            end
        else
            for i=1,#delegate.data do
                delegate.data[i].num = math.ceil(delegate.data[i].num + 0)
            end
        end
    end
   
    self.Image_1:addChild(self:createView(delegate.data))

end

--
function RewardDialog:createView(data)
    local tableView = cc.TableView:create(cc.size(420, 200))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(20, 20)

    local function numberOfCellsInTableView(tableView)
        return table.nums(data)
    end

    local function cellSizeForTable(tableView,idx)
        return 120, 120
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.common.ItemIcon.new()
            cell:addChild(item)
            cell.item = item
            cell.item:setPositionX(49)
        end

        cell.item:setData(data[idx + 1])
        -- cell.item:setVisible(data[idx + 1].num > 0)
        cell.item.fatherSprite:setSwallowTouches(false)

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

return RewardDialog
