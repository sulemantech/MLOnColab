Object.values = function(object) {
	return Object.keys(object).map(function(key) { return object[key] });
}

Array.prototype.includes = function(searchElement, fromIndex) {
	return this.indexOf(searchElement, fromIndex) !== -1;
}

String.prototype.includes = function(searchString, position) {
	return this.indexOf(searchString, position) !== -1
}

function setInterval(callback, interval) {
	interval = interval / 1000;
	$.Schedule(interval, function reschedule() {
		$.Schedule(interval, reschedule);
		callback();
	});
}

function createEventRequestCreator(eventName) {
	var idCounter = 0;
	return function(data, callback) {
		var id = ++idCounter;
		data.id = id;
		GameEvents.SendCustomGameEventToServer(eventName, data);
		var listener = GameEvents.Subscribe(eventName, function(data) {
			if (data.id !== id) return;
			GameEvents.Unsubscribe(listener);
			callback(data)
		});

		return listener;
	}
}

function SubscribeToNetTableKey(tableName, key, callback) {
    var immediateValue = CustomNetTables.GetTableValue(tableName, key) || {};
    if (immediateValue != null) callback(immediateValue);
    CustomNetTables.SubscribeNetTableListener(tableName, function (_tableName, currentKey, value) {
        if (currentKey === key && value != null) callback(value);
    });
}

function GetDotaHud() {
    var panel = $.GetContextPanel();
    while (panel && panel.id !== 'Hud') {
        panel = panel.GetParent();
	}

    if (!panel) {
        throw new Error('Could not find Hud root from panel with id: ' + $.GetContextPanel().id);
	}

	return panel;
}

function FindDotaHudElement(id) {
	return GetDotaHud().FindChildTraverse(id);
}

var useChineseDateFormat = $.Language() === 'schinese' || $.Language() === 'tchinese';
/** @param {Date} date */
function formatDate(date) {
	return useChineseDateFormat
		? date.getFullYear() + '-' + date.getMonth() + '-' + date.getDate()
		: date.getMonth() + '/' + date.getDate() + '/' + date.getFullYear();
}


function Selection_Remove(msg)
{
    var remove_entities = msg.entities
    var selected_entities = GetSelectedEntities();
    for (var i in remove_entities) {
        var index = selected_entities.indexOf(remove_entities[i])
        if (index > -1)
            selected_entities.splice(index, 1)
    };

    if (selected_entities.length == 0)
    {
        Selection_Reset()
        return
    }

    for (var i in selected_entities) {
        if (i==0)
            GameUI.SelectUnit(selected_entities[i], false)
        else
            GameUI.SelectUnit(selected_entities[i], true)
    };
    //$.Schedule(0.03, SendSelectedEntities);
}

function Selection_New(msg)
{
    var entities = msg.entities
    //$.Msg("Selection_New ", entities)
    for (var i in entities) {
        if (i==1)
            GameUI.SelectUnit(entities[i], false) //New
        else
            GameUI.SelectUnit(entities[i], true) //Add
    };
    //$.Schedule(0.03, SendSelectedEntities);
}

function GetSelectedEntities() {
    return Players.GetSelectedEntities(Players.GetLocalPlayer());
}

function SendSelectedEntities() {
    GameEvents.SendCustomGameEventToServer("selection_update", {entities: GetSelectedEntities()})
}

function Selection_Reset()
{
    var playerID = Players.GetLocalPlayer()
    var heroIndex = Players.GetPlayerHeroEntityIndex(playerID)
    GameUI.SelectUnit(heroIndex, false)
    //$.Schedule(0.03, SendSelectedEntities);
}

function Selection_Add(msg)
{
    var entities = msg.entities
    for (var i in entities) {
        //$.Msg("Selection_Add ", entities[i], " to ",GetSelectedEntities())
        GameUI.SelectUnit(entities[i], true)
    };
    //$.Schedule(0.03, SendSelectedEntities);
}
(function () {
GameEvents.Subscribe( "selection_remove", Selection_Remove);
GameEvents.Subscribe( "selection_new", Selection_New);
GameEvents.Subscribe( "selection_add", Selection_Add);
})();