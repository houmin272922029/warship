return function(controller)
    print("bonus module")
    local dialog = require("coupon_shop.src.MainDialog").new()
    dialog:addTo(controller)
end
