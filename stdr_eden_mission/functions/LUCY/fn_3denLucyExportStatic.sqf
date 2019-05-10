/*
 * Author : Sparfell
 * Exporter les unités statiques sélectionnée dans 3DEN pour LUCY
 * 
 * Parameters
 * 0 - group : group selected in 3DEN for instance
 *
 * Return : STRING : the text to past in your script
*/
params ["_group"];
private ["_txt","_txtFinal","_pos"];

_txt = "";
_txtFinal = "";

{
	_pos = getPosASL _x;
	_pos = [(_pos #0),(_pos #1),(_pos #2),(getDir _x)];
	_txt = format ["[%1,%2,%3,%4,[""NOTHING""],-1,""""] call GDC_fnc_lucySpawnStaticInf;",str (typeOf _x),[_pos],(side _x),str (unitPos _x)];
	_txtFinal = _txtFinal + _txt;
} forEach (units _group);

[(units _group)] call STDR_fnc_conditionOfPresence;

copyToClipboard _txtFinal;
_txtFinal;