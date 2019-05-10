/*
 * Author : Sparfell
 * Exporter tous les IA de la mission dans 3DEN pour LUCY
 * 
 * Parameters
 * None
 *
 * Return : STRING : the text to past in your script
*/
//TODO : include or exclude civilians (condition as parameter)

private ["_allIAgroups","_allWP","_infantryGroups","_staticUnitsGroups","_group","_txt","_txtFinal","_br","_validatedGroups","_ignoredGroups","_driverFound","_gunnerFound"];

_txt = "";
_txtFinal = "";
_br = toString [13,10];

_globalExport = false;
_allIAgroups = [];
if ((count get3DENSelected "group") > 0) then {
	_allIAgroups = get3DENSelected "group";
} else {
	_allIAgroups = all3DENEntities #1;
	_allIAgroups = _allIAgroups select {!(((leader _x) get3DENAttribute "ControlSP")#0) && !(((leader _x) get3DENAttribute "ControlMP")#0)};
	_allIAgroups = _allIAgroups select {(count units _x) > 0};
	_txtFinal = _txtFinal + "/* EXPORT DE TOUTE LA MISSION */" + _br;
	_globalExport = true;
};

_allWP = all3DENEntities #4;

STDR_infantryGroups = _allIAgroups select {(vehicle (leader _x) == (leader _x))};
STDR_vehicleGroups = _allIAgroups - STDR_infantryGroups;

// Tri des véhicules
_validatedGroups = [];
_ignoredGroups = [];
{
	_group = _x;
	_driverFound = false;
	_gunnerFound = false;
	{
		if ((assignedVehicleRole _x)#0 == "Driver") then {
			_driverFound = true;
		};
		if ((assignedVehicleRole _x)#0 == "Turret") then {
			_gunnerFound = true;
		};
	} forEach (units _group);
	if (_driverFound OR _gunnerFound) then {
		_validatedGroups = _validatedGroups + [_group];
	} else {
		_ignoredGroups = _ignoredGroups + [_group];
	};
} forEach STDR_vehicleGroups;
STDR_vehicleGroups = _validatedGroups;


_staticUnitsGroups = [];
{
	_group = _x;
	_units = units _group;
	_wps = _allWP select {(_x #0) == _group};
	if ((count _units < 2) && (count _wps < 1)) then {
		_staticUnitsGroups = _staticUnitsGroups + [_group];
	};
} forEach STDR_infantryGroups;
STDR_infantryGroups = STDR_infantryGroups - _staticUnitsGroups;


// Export static units
if ((count _staticUnitsGroups) > 0) then {
	if (_globalExport) then {_txtFinal = _txtFinal + _br + "/* Unites statiques */" + _br;};
	{
		_txt = [_x] call STDR_fnc_3denLucyExportStatic;
		_txtFinal = _txtFinal + _br + _txt;
		_txt = [_x] call STDR_fnc_getDirFromLocation;
		_txtFinal = _txtFinal + _txt;
	} forEach _staticUnitsGroups;
};


// Export Vehicle groups
if ((count STDR_vehicleGroups) > 0) then {
	if (_globalExport) then {_txtFinal = _txtFinal + _br + _br + "/* Groupes vehicules */";};
	{
		_txt = [_x] call STDR_fnc_getDirFromLocation;
		_txtFinal = _txtFinal + _br + _br + _txt;
		_txt = [_x] call STDR_fnc_3denLucyExportGroupVeh;
		_txtFinal = _txtFinal + _txt;
	} forEach STDR_vehicleGroups;
};


// Export infantry groups
if ((count STDR_infantryGroups) > 0) then {
	if (_globalExport) then {_txtFinal = _txtFinal + _br + _br + "/* Groupes d'infanterie */";};
	{
		_txt = [_x] call STDR_fnc_getDirFromLocation;
		_txtFinal = _txtFinal + _br + _br + _txt;
		_txt = [_x] call STDR_fnc_3denLucyExportGroupInf;
		_txtFinal = _txtFinal + _txt;
	} forEach STDR_infantryGroups;
};


if (count _ignoredGroups > 0) then {
	// Groupes ignorés
	_txt = "// Groupes ignores car places dans le cargo d'un vehicule qui ne leur appartient pas :";
	_txtFinal = _txtFinal + _br + _br + _txt + _br + "// " + (str _ignoredGroups);
};

// Export final
_txtFinal = _txtFinal + _br;
copyToClipboard _txtFinal;

// Message
systemChat "";
_txt = str (count (_allIAgroups - _ignoredGroups));
if ((count get3DENSelected "group") == 0) then {
	systemChat "Export vers LUCY : Export de tous les groupes de la mission.";
} else {
	systemChat "Export vers LUCY : Export des groupes sélectionnés.";
};
if (_txt == "1") then {
	systemChat (_txt + " groupe a été exporté vers le presse papier.");
} else {
	systemChat (_txt + " groupes ont été exportés vers le presse papier.");
};

_txtFinal;