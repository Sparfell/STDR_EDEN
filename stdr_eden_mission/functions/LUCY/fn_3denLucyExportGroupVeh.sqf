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
	"_txt","_txtFinal","_br","_string",
	"_veh","_pos","_side","_vehname","_units",
	"_skill","_types","_wpList","_flyparam"
];

_txt = "";
_txtFinal = "";
_br = toString [13,10];

_veh = vehicle (leader _group);
_units = units _group;
_pos = (getpos _veh);
//_pos = [_pos #0,_pos #1,((_pos #2) + 0.1)];
_side = [side _group] call STDR_fnc_3denLucyConvertSide;
_skill = skill (leader _group);
_wpList = all3DENEntities #4;
_wpList = _wpList select {(_x #0) == _group};
_types = [];
{
	_types = _types + [typeOf _x];
} forEach _units;

// Spawn du groupe
if ((STDR_vehicleExportMode > 0) OR ((_veh isKindOf "air") && (_pos#2 > 25))) then {
	if ((_veh isKindOf "air") && (_pos#2 > 25)) then {
		_flyparam = ["FLY",_pos#2,(if (_veh iskindof "Helicopter") then {0} else {300})];
	} else {
		_flyparam = ["NONE",0,0];
	};
	_txt = format ["_group = [%1,%2,%3,%4,%5,%6,%7] call GDC_fnc_lucySpawnVehicle;",_pos,_side,str (typeOf _veh),_types,getdir _veh,_flyparam,_skill];
	_txtFinal = _txtFinal + _br + _txt;
	[_units + [_veh]] call STDR_fnc_conditionOfPresence;
	_txtFinal = _txtFinal + _br + "_veh = _group #1; _group = _group #0;";
} else {
	_vehname = (_veh get3DENAttribute "Name")#0;
	if (_vehname == "") then {
		_vehname = format ["stdr_lucy_vehicle_%1_%2",(round (_pos#0)),(round (_pos#1))];
		//STDR_vehicleNumber = STDR_vehicleNumber + 1;
		_veh set3DENAttribute ["Name",_vehname];
	};
	_txt = format ["_group = [%1,%2,%3,%4] call GDC_fnc_lucySpawnVehicleCrew;",_vehname,_side,_types,_skill];
	_txtFinal = _txtFinal + _br + _txt;
	[_units] call STDR_fnc_conditionOfPresence;
	_txtFinal = _txtFinal + _br + (format ["_veh = %1;",_vehname]);
};

//Cas d'une Patrouille avec waypoints
if (count _wpList > 0) then {
	_txt = [_group,_wpList,1] call STDR_fnc_3denLucyExportWaypoints;
	_txtFinal = _txtFinal + _br + _txt;
};

//PLUTO
_txt = [_group] call STDR_fnc_3denLucyPluto;
if (count _txt > 0) then {
	_txt = "_group " + _txt;
	_txtFinal = _txtFinal + _br + _txt;
};

copyToClipboard _txtFinal;
_txtFinal;