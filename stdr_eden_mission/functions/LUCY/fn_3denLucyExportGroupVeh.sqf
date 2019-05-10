/*
 * Author : Sparfell
 * Exporter un groupe de 3DEN pour LUCY
 * 
 * Parameters
 * 0 - group : group selected in 3DEN for instance
 *
 * Return : STRING : the text to past in your script
*/
params ["_group"];
private [
	"_txt","_txtFinal","_br",
	"_veh","_pos","_side",
	"_units","_driver","_gunner","_commander",
	"_timer","_wpTimerList",
	"_skill","_types","_wpList","_wpPosList","_flyparam"
];

_txt = "";
_txtFinal = "";
_br = toString [13,10];

_veh = vehicle (leader _group);
_units = units _group;
_driver = driver _veh;
_gunner = gunner _veh;

/*
if !(_driver in _units) exitwith {
	_txt = "//Groupe embarqué non généré";
	_txtFinal = _txtFinal + _br + _txt;
	copyToClipboard _txtFinal;
	_txtFinal;
};
*/

_pos = getpos _veh;
_side = side _group;
_skill = skill (leader _group);
_wpList = all3DENEntities #4;
_wpList = _wpList select {(_x #0) == _group};
// Spawn du groupe
_types = [];
{
	_types = _types + [typeOf _x];
} forEach _units;
_flyparam = if ((_veh isKindOf "air") && (_pos#2 > 25)) then {["FLY",_pos#2,(if (_veh iskindof "Helicopter") then {0} else {300})]} else {["NONE",0,0]};
_txt = format ["_group = [%1,%2,%3,%4,%5,%6,%7] call GDC_fnc_lucySpawnVehicle;",_pos,_side,str (typeOf _veh),_types,getdir _veh,_flyparam,_skill];
_txtFinal = _txtFinal + _br + _txt;

//Cas d'une Patrouille avec waypoints
if (count _wpList > 0) then {
	_txt = [_group,_wpList,1] call STDR_fnc_3denLucyExportWaypoints;
	_txtFinal = _txtFinal + _br + _txt;
};

[_units + [_veh]] call STDR_fnc_conditionOfPresence;

copyToClipboard _txtFinal;
_txtFinal;