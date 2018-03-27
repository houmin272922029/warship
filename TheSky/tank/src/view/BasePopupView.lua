local BasePopupView = qy.class("BasePopupView", qy.tank.widget.PopupWindowWrapper)

function BasePopupView:ctor()
    BasePopupView.super.ctor(self)

    -- qy.Event.dispatch(qy.Event.SERVICE_LOADING_SHOW)
    self:toShowPopupEffert()
end

return BasePopupView