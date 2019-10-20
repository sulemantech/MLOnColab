function SelectionCourierUpdate(msg) {
    var needCourier = msg.newCourier;
    var selected_entities = GetSelectedEntities();
    var haveCourierInSelect = false;
    var selectionCounter = 0;
    var removeTatget = msg.removeCourier;

    for (var i in selected_entities) {
        if (Entities.IsCourier(selected_entities[i])){
            haveCourierInSelect = true;
        }
        selectionCounter+=1;
    };

    Selection_Remove({entities:removeTatget})
    if (haveCourierInSelect && selectionCounter < 2){
        Selection_New({ entities:needCourier });
    }else if(haveCourierInSelect){
        Selection_Add({ entities:needCourier });
    }
}

(function () {
    GameEvents.Subscribe( "selection_courier_update", SelectionCourierUpdate);
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