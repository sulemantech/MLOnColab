function FindDotaHudElement (id) {
    return GetDotaHud().FindChildTraverse(id);
}

function GetDotaHud ()
{
    var p = $.GetContextPanel();
    try {
        while (true) {
            if (p.id === 'Hud') {
                return p;
            } else {
                p = p.GetParent();
            }
        }
    } catch (e) {}
}

(function () {
    var playerId = Players.GetLocalPlayer()
    var selectCourietButton = FindDotaHudElement('SelectCourierButton')
    var deliverItemsButton = FindDotaHudElement('DeliverItemsButton')

    selectCourietButton.SetPanelEvent("onactivate", function () {
        GameEvents.SendCustomGameEventToServer("courier_custom_select", {playerId: playerId})
    })
    deliverItemsButton.SetPanelEvent("onactivate", function () {
        GameEvents.SendCustomGameEventToServer("courier_custom_select_deliever_items", {playerId: playerId})
    })
})();