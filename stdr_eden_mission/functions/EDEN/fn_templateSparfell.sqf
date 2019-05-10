/*
	Faster Better Stronger
*/
private ["_trg","_hc"];

[] call STDR_fnc_createEndTrigger;

if (({(_x get3DENAttribute 'Name') select 0 == 'HC_Slot' } count (all3DENEntities #3)) < 1) then {
	_hc = create3DENEntity ['Logic', 'HeadlessClient_F', screenToWorld [0.45,0.45]];
	_hc set3DENAttribute ['ControlMP',true];
	_hc set3DENAttribute ['ControlSP',false];
	_hc set3DENAttribute ['Description','HC_Slot'];
	_hc set3DENAttribute ['Name','HC_Slot'];
};

set3DENMissionAttributes [['Multiplayer','respawn',1],['Scenario','EnableDebugConsole',1],['Multiplayer','RespawnTemplates',['EndMission','Spectator']],['Scenario','GDC_Inventory',1],['Scenario','GDC_Roster',1],['Scenario','GDC_DeleteSeagull',1],['Scenario','GDC_AcreSpectator',1]];