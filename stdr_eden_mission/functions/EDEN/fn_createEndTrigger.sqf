/*
 * create a radio trigger that end the mission
 * 
 * Parameters
 * 0 - ARRAY of objects : objects selected in 3DEN for instance
 * 1 - NUMBER : export mode : 0=ASL [x,y,z,dir] ; 1=[x,y,z]
 *
 * Return : Nothing
*/
private ["_trg"];

if (({(_x get3DENAttribute 'ActivationBy') select 0 == 'ALPHA' } count (all3DENEntities #2)) < 1) then {
	_trg = create3DENEntity ['Trigger','EmptyDetector',screenToWorld [0.5,0.5]];
	_trg set3DENAttribute ['text',"Couper la mission"];
	_trg set3DENAttribute ['ActivationBy',"ALPHA"];
	_trg set3DENAttribute ['onActivation',"[""end1"",true,4] call BIS_fnc_endMission;"];
};