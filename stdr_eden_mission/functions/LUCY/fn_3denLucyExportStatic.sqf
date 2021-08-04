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
private ["_txt","_txtFinal","_pos","_skill"];

_txt = "";
_txtFinal = "";

{
	_pos = getPosASL _x;
	_pos = [(_pos #0),(_pos #1),(_pos #2),(getDir _x)];
	_skill = ((_x get3DENAttribute "skill")#0);
	_txt = format ["[%1,%2,%3,%4,[""NOTHING""],%5,%6] call GDC_fnc_lucySpawnStaticInf;",str (typeOf _x),[_pos],([(side _x)] call STDR_fnc_3denLucyConvertSide),str (unitPos _x),_skill,str ((_group get3DENAttribute "Init")#0)];
	_txtFinal = _txtFinal + _txt;
} forEach (units _group);

[(units _group)] call STDR_fnc_conditionOfPresence;

copyToClipboard _txtFinal;
_txtFinal;