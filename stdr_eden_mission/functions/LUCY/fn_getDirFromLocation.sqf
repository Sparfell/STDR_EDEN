/*
 * Author : Sparfell
 * Créer un string qui indique la position d'un groupe relativement à la location la plus proche
 * 
 * Parameters
 * 0 - group : group selected in 3DEN for instance
 *
 * Return : STRING
*/
params ["_group"];
private ["_pos","_nearbyLocations","_txt","_loc","_locPos","_dir","_azimuth","_dist"];

_txt = "";

_pos = getpos (leader _group);

_nearbyLocations = nearestLocations [_pos, ["Name","NameCity","NameCityCapital","NameLocal","NameMarine","NameVillage","Airport","Hill"],99999,_pos];

if ((count _nearbyLocations) > 0) then {
	_loc = _nearbyLocations #0;
	_locPos = locationPosition _loc;
	_txt = text _loc;
} else {
	_txt = "NO LOCATION";
	_locPos = [0,0,0];
};
if (_txt == "NO LOCATION") exitwith {"// "+_txt;};

_dir = _locPos getdir _pos;
_azimuth = [_dir,45] call BIS_fnc_roundDir;
_azimuth = switch (_azimuth) do {
	case 360;
	case 0 : {"Nord"};
	case 45 : {"Nord-Est"};
	case 90 : {"Est"};
	case 135 : {"Sud-Est"};
	case 180 : {"Sud"};
	case 225 : {"Sud-Ouest"};
	case 270 : {"Ouest"};
	case 315 : {"Nord-Ouest"};
	default {"ERROR"};
};
_dist = round (_pos distance2D _locPos);
_txt = format ["// %3 - %2 - %1m",_dist,_azimuth,_txt];
_txt;