/*
 * Author : Sparfell + Karel Moricky (code from BIS_fnc_exportCfgGroups)
 * Export groups to CfgGroups configs
 * 
 * Parameters
 * 0 - ARRAY of group : groups selected in 3DEN for instance
 * 1 - STRING (optionnal) : author TAG for use in classes (default="TAG")
 *
 * Return : STRING : the text to past in your config file
*/

params ["_groups",["_tag","TAG"]];

private ["_txtFinal","_txt","_tab","_line4","_line5","_group","_side","_sideL","_pos","_m"];

_txtFinal = "";

_tab = toString [9];
_line4 = (toString [13,10]) + _tab + _tab + _tab + _tab;
_line5 = _line4 + _tab;

{
	_group = _x;
	_side = ((side (leader _group)) call BIS_fnc_sideID);
	_sideL = switch (_side) do {
		case 0: {"o"};
		case 1: {"b"};
		case 2;
		default {"n"};
	};
	_txt = format [
		"%1class %3_NewGroup_%7%1{%2name = ""NewGroup"";%2side = %4;%2faction = %6;%2icon = ""\A3\ui_f\data\map\markers\nato\%5_inf.paa"";",
		_line4,
		_line5,
		_tag,
		_side,
		_sideL,
		str (faction (leader _group)),
		(_foreachindex + 1)
	];
	_txtFinal = _txtFinal + _txt;

	//Each unit of the group
	_pos = [0,0];
	_m = 5;
	{
		//Produce _txt
		_txt = format [
			"%7class Unit%1	{side = %2; vehicle = ""%3""; rank = ""%4""; position[] = {%5,%6,0};};",
			_foreachindex,
			_side,
			typeof _x,
			((_x get3DENAttribute "rank")#0),
			_pos#0,
			_pos#1,
			_line5
		];
		_txtFinal = _txtFinal + _txt;
		// Update _pos
		if ((_foreachindex mod 2) == 0) then {
			_pos = [_m,-_m];
		} else {
			_pos = [-_m,-_m];
			_m = _m + 5;
		};
	} forEach (units _group);
	// end of this group
	_txt = format ["%1};",_line4];
	_txtFinal = _txtFinal + _txt;
} forEach _groups;

copyToClipboard _txtFinal;
_txtFinal;