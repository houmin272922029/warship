local _proLayer
local _uiTable
local _webView

local Screen_iPad = 2
local Screen_iphone3_7Inch = 0

local function loadAgreementText(  )
    local size = CCSizeMake(winSize.width * 0.8, winSize.height * 0.7)
    if not _webView then
        _webView = ZYWebView:new()
    end
    print(screenType)
    if screenType >= Screen_iPad then
        _webView:showWebView(string.format("%suser_agreement_%s.htm",userdata.selectServer.url, "zh_CN") ,88 , 110, 860, 550, 0)
    elseif screenType == Screen_iphone3_7Inch then
        _webView:showWebView(string.format("%suser_agreement_%s.htm",userdata.selectServer.url, "zh_CN"),40 , 60, 400, 230, 0)
    else
        _webView:showWebView(string.format("%suser_agreement_%s.htm",userdata.selectServer.url, "zh_CN"),55 , 65, 460, 220, 0)
    end
    -- _webView:showWebView(string.format("%suser_agreement_%s.htm",userdata.selectServer.url, "zh_CN"),winSize.width * 0.1 , winSize.height * 0.2, size.width, size.height, 0)
end

local function backToLastScene(  )  
    _webView:removeWebView()
    _proLayer:removeFromParentAndCleanup(true)
end

local function loadArtResourceFun(  )
    _uiTable = loadUIConfFileFun("protocolConfigure", _proLayer, _scene)

    local close = _uiTable["closeMenu"]
    if close then
        close:registerScriptTapHandler(backToLastScene)
    end
    loadAgreementText()
end

local function init(  )

    _proLayer = CCLayer:create()
    _proLayer:setAnchorPoint(ccp(0.5, 0.5))
    _proLayer:setPosition(0, 0)
    loadArtResourceFun()

end

function protocolSceneFunc( scene )

    _scene = scene
    init()

    return _proLayer
end