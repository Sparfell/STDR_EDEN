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
private ["_txt","_txtFinal","_br","_strGroup","_pos","_side","_units","_skill","_types","_wpList","_wpPosList","_timer","_wpTimerList","_wpLast","_wpLastType","_wpLastPos","_NearMarkers","_bList"];

_txt = "";
_txtFinal = "";
_br = toString [13,10];

_pos = getpos (leader _group);
_side = side _group;
_units = units _group;
_skill = (((leader _group) get3DENAttribute "skill")#0);

_wpList = all3DENEntities #4;
_wpList = _wpList select {(_x #0) == _group};

// Spawn du groupe
_types = [];
{
	_types = _types + [typeOf _x];
} forEach _units;
_txt = format ["_groupInf = [%1,%2,%3,%4] call GDC_fnc_lucySpawnGroupInf;",_pos,([_side] call STDR_fnc_3denLucyConvertSide),_types,_skill];
_txtFinal = _txtFinal + _br + _txt;

//Cas d'une Patrouille avec waypoints
if (count _wpList > 0) then {
	_txt = [_group,_wpList,0] call STDR_fnc_3denLucyExportWaypoints;
	_txtFinal = _txtFinal + _br + _txt;
};

//PLUTO
_txt = [_group] call STDR_fnc_3denLucyPluto;
if (count _txt > 0) then {
	_txt = "_groupInf " + _txt;
	_txtFinal = _txtFinal + _br + _txt;
};

[_units] call STDR_fnc_conditionOfPresence;

copyToClipboard _txtFinal;
_txtFinal;