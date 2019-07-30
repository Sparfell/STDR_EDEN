/*
 * Calculer la distance entre un point et un autre
 * 
 * Parameters
 * NONE
 *
 * Return : NUMBER : the distance between the two points
*/
private ["_menuData","_d"];

_menuData = (uiNamespace getVariable "bis_fnc_3DENEntityMenu_data");
_menuData params ["_posEntity3D","_entity"];

if (isnil "stdr_3denCalculateDistancePosA") then {
	stdr_3denCalculateDistancePosA = _posEntity3D;
} else {
	_d = stdr_3denCalculateDistancePosA distance2D _posEntity3D;
	systemChat (format ["Distance = %1 mètres",_d]);
	stdr_3denCalculateDistancePosA = nil;
	copyToClipboard str _d;
	_d;
};