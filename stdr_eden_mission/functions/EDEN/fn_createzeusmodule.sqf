/*
	Creates a Zeus Module that activates if the param "debug" is active
*/
if (({(_x get3DENAttribute 'Name') select 0 == 'zeus_for_debug' } count (all3DENEntities #3)) < 1) then {
	private _zeus = create3DENEntity ['Logic', 'ModuleCurator_F', screenToWorld [0.5,0.5]];
	_zeus set3DENAttribute ['Name','zeus_for_debug'];
	_zeus set3DENAttribute ['presenceCondition',"(([""debug"",0] call BIS_fnc_getParamValue) == 1)"];
	_zeus set3DENAttribute ['ModuleCurator_F_Owner',"#adminLogged"];
	_zeus set3DENAttribute ['ModuleCurator_F_Addons',3];
} else {
	systemChat "ERREUR : le module Zeus de debug existe déjà dans la mission";
};