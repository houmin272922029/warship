
qy.tank.utils.cache.CachePoolUtil.addPlist("Resources/common/button/common_button", 1)

local ServerScene = qy.class("ServerScene", qy.tank.view.scene.BaseScene)

local ServerItem = class("ServerItem", function()
    return cc.TableViewCell:new()
end)

function ServerItem:ctor(next)
    self:makeText("name", 75, 24)
    self:makeText("url", 45, 14)
    self:makeText("version", 24, 16)

    self:makeButton(function()
        qy.SERVER_DOMAIN = self._serverData.domain
        qy.SERVER_PORT = self._serverData.port
        qy.SERVER_PATH = self._serverData.path
        qy.SERVER_VERSION = self._serverData.version
        qy.tank.utils.Http.seturl()
        next()
    end, qy.TextUtil:substitute(29001), 950)

    self:makeButton(function()
        -- qy.SERVER_DOMAIN = self._serverData.domain
        -- qy.SERVER_PORT = self._serverData.port
        -- qy.SERVER_PATH = self._serverData.path
        -- qy.SERVER_VERSION = self._serverData.version
        -- next()
    end, qy.TextUtil:substitute(29002), 790)
end

function ServerItem:setData(serverData)
    self._serverData = serverData
    for k,v in pairs(serverData) do
        if self[k] then
            self[k]:setString(v)
        end
    end
    self.url:setString("http://" .. serverData.domain .. ":" ..serverData.port .. "/" .. serverData.path)
    return self
end

function ServerItem:makeText(name, y, fontSize)
    local text = ccui.Text:create(qy.TextUtil:substitute(29003), qy.res.FONT_NAME, fontSize)
    text:setTextColor(cc.c4b(255, 255, 255, 255))
    text:setAnchorPoint(0, 1)
    text:setPosition(10, y)
    text:addTo(self)

    self[name] = text
end

function ServerItem:makeButton(next, text, x)
    local button = ccui.Button:create("Resources/common/button/btn_4.png", "Resources/common/button/anniulan02.png", "", 1)
    button:setTouchEnabled(true)
    button:setSwallowTouches(false)
    button:setTitleText(text)
    button:setTitleFontName(qy.res.FONT_NAME)
    button:setTitleFontSize(24)
    button:getTitleRenderer():enableOutline(cc.c4b(0,0,0,255),1)
    button:addClickEventListener(next)
    button:setAnchorPoint(1, 0.5)
    button:setPosition(x, 40)
    button:addTo(self)
end

function ServerScene:ctor(next)
    self:onNodeEvent("enter", function()
        co(function()
            local status, data = yield(qy.tank.utils.Requests.get("http://www.miniserver.io/tank/server.json"))
            if status == 200 then
                return qy.json.decode(data)
            end
        end, function(servers)
            if servers == nil then
                qy.hint(qy.TextUtil:substitute(29004))
                next()
            else
                self:createTableView(servers, next)
            end
        end)
    end)

end

function ServerScene:createTableView(servers, next)
    for i,v in ipairs(servers) do
        print(v.name)
    end

    local text = ccui.Text:create(qy.TextUtil:substitute(29005), qy.res.FONT_NAME, 38)
    text:setTextColor(cc.c4b(255, 255, 255, 255))
    text:setPosition(display.cx, display.height * 0.90)
    text:addTo(self)

	local tableView = cc.TableView:create(cc.size(960, 600))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPositionX((display.width - 960) / 2)

    local function numberOfCellsInTableView(tableView)
        return #servers
    end

    local function cellSizeForTable(tableView, idx)
        return 960, 80
    end

    local function tableCellAtIndex(tableView, idx)
        return (tableView:dequeueCell() or ServerItem.new(next)):setData(servers[idx + 1])
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    tableView:addTo(self)
end

return ServerScene
