params ["_group"];
private ["_speed","_behaviour","_combatmode","_formation","_behaviourArray"];

_speed = [((_group get3DENAttribute "speedMode")#0) + 1] call STDR_fnc_3denLucyConvertSpeed;
_behaviour = ((_group get3DENAttribute "behaviour")#0);
_combatmode = ((_group get3DENAttribute "combatMode")#0);
_formation = [((_group get3DENAttribute "formation")#0) + 1] call STDR_fnc_3denLucyConvertFormation;

_behaviourArray = [_speed,_behaviour,_combatmode,_formation];
_behaviourArray;