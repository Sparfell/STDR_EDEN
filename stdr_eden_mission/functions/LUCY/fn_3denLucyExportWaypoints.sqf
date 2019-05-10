params ["_group","_wpList","_mode"];
private [
	"_strGroup","_wpLast","_wpLastType","_wpLastPos","_txt",
	"_wpTimerList","_bList","_NearMarkers",
	"_condition","_timeout","_behavior1","_formation1","_behavior2","_formation2","_code","_patrol",
	"_wpPosList","_wpPosList2"
];

_txt = "";
if (_mode == 1) then {
	_strGroup = "[(_group #0),";
} else {
	_strGroup = "[_groupInf,";
};

// dans le cas de TR unload on prend ce WP au lieu du dernier WP
if (({(_x get3DENAttribute "itemClass")#0 == "TransportUnload"} count _wpList) > 0) then {
	_wpLast = _wpList findIf {(_x get3DENAttribute "itemClass")#0 == "TransportUnload"};
	_wpLast = _wpList select _wpLast;
	_wpLastType = (_wpLast get3DENAttribute "itemClass")#0;
	_wpLastPos = (_wpLast get3DENAttribute "position")#0;
} else {
	_wpLast = _wpList #((count _wpList) -1);
	_wpLastType = (_wpLast get3DENAttribute "itemClass")#0;
	_wpLastPos = (_wpLast get3DENAttribute "position")#0;
};

switch (_wpLastType) do {
	case "Cycle": { // Patrouille CYCLE avec WP définis
		_wpPosList = [];
		_wpTimerList = [];
		{
			_pos = _x get3DENAttribute "position";
			_wpPosList = _wpPosList + _pos;
			_timer = _x get3DENAttribute "timeout";
			_wpTimerList = _wpTimerList + _timer;
		} forEach _wpList;
		_txt = _strGroup + format ["%1,%2,%3,%4,%5,30,%6] call GDC_fnc_lucyAddWaypointListMoveCycle;",_wpPosList,str(speedMode _group),str(behaviour (leader _group)),str(combatMode _group),str(formation _group),_wpTimerList];
	};
	case "Move": {// Patrouille random dans une zone
		_NearMarkers = (all3DENEntities #5) select {(((_x get3DENAttribute "position")#0) distance2D _wpLastPos) < 10};
		_NearMarkers = [_NearMarkers,[_wpLastPos],{(((_x get3DENAttribute "position")#0) distance2D _input0)},"ASCEND",{(((_x get3DENAttribute "markerType")#0) in [0,1])}] call BIS_fnc_sortBy;
		if ((count _wpList == 1) && (count _NearMarkers > 0)) then {
			_bList = if (surfaceIsWater _pos) then {["ground"]} else {["water"]};
			_wpLastType = "MOVE";
			_txt = _strGroup + format ["%1,[%2,%3,%4,%5,%6],%7] call GDC_fnc_lucyGroupRandomPatrol;",str (_NearMarkers #0),str _wpLastType,str(speedMode _group),str(behaviour (leader _group)),str(combatMode _group),str(formation _group),_bList];
		} else {
			_txt =  "//Wps qui finissent en MOVE non pris en compte";
		};
	};
	case "SeekAndDestroy": {// Renfort
		_wpPosList = [];
		{
			_pos = _x get3DENAttribute "position";
			_wpPosList = _wpPosList + _pos;
		} forEach _wpList;
		_condition = (((_wpList #0) get3DENAttribute "condition")#0);
		_timeout = (((_wpList #0) get3DENAttribute "timeout")#0);
		_speed = (((_wpList #0) get3DENAttribute "speedMode")#0);
		_speed = [_speed] call STDR_fnc_3denLucyConvertSpeed;
		_behavior1 = [_speed,(((_wpList #0) get3DENAttribute "behaviour")#0),(((_wpList #0) get3DENAttribute "combatMode")#0)];
		_formation1 = (((_wpList #0) get3DENAttribute "formation")#0);
		_formation1 = [_formation1] call STDR_fnc_3denLucyConvertFormation;
		_speed = ((_wpLast get3DENAttribute "speedMode")#0);
		_speed = [_speed] call STDR_fnc_3denLucyConvertSpeed;
		_behavior2 = [_speed,((_wpLast get3DENAttribute "behaviour")#0),((_wpLast get3DENAttribute "combatMode")#0)];
		_formation2 = ((_wpLast get3DENAttribute "formation")#0);
		_formation2 = [_formation2] call STDR_fnc_3denLucyConvertFormation;
		_code = ((_wpLast get3DENAttribute "onActivation")#0);
		_wpLastType = "SAD";
		// pour patrol (dernier param)
		_NearMarkers = (all3DENEntities #5) select {(((_x get3DENAttribute "position")#0) distance2D _wpLastPos) < 10};
		_NearMarkers = [_NearMarkers,[_wpLastPos],{(((_x get3DENAttribute "position")#0) distance2D _input0)},"ASCEND",{(((_x get3DENAttribute "markerType")#0) in [0,1])}] call BIS_fnc_sortBy;
		_patrol = if (count _NearMarkers > 0) then {str (_NearMarkers #0)} else {0};

		_txt = _strGroup + format ["%1,%2,%3,%4,%5,%6,%7,%8,%9,%10] call GDC_fnc_lucyReinforcement;",_wpPosList,str _condition,_timeout,_behavior1,str _formation1,str _wpLastType,_behavior2,str _formation2,str _code,_patrol];
	};
	case "TransportUnload": {
		// find transported group, create the string for it and remove this group from the infantry groups list
		// Group leader must be synced with the vehicle
		_veh = vehicle (leader _group);
		_inf =  (get3DENConnections _veh) select {typeName _x == "ARRAY"};
		_inf =  _inf select {(_x #0) == "Sync"};
		if (count _inf > 0) then {
			_inf = (_inf #0)#1;
			_inf = group _inf;
			_txt = [_inf] call STDR_fnc_3denLucyExportGroupInf;
			STDR_infantryGroups = STDR_infantryGroups - [_inf];
		};

		// Create the string for the reinforce function
		
		_wpPosList = [];
		{
			_pos = _x get3DENAttribute "position";
			_wpPosList = _wpPosList + _pos;
		} forEach (_wpList select {(_x #1) <= (_wpLast#1)});
		//} forEach (_wpList select [0,((_wpLast#1)+1)]);
		_wpPosList2 = [];
		{
			_pos = _x get3DENAttribute "position";
			_wpPosList2 = _wpPosList2 + _pos;
		} forEach (_wpList select {(_x #1) > (_wpLast#1)});
		//} forEach (_wpList select [((_wpLast#1) +1),((count _wpList) -1)]);
		_condition = (((_wpList #0) get3DENAttribute "condition")#0);
		_timeout = (((_wpList #0) get3DENAttribute "timeout")#0);
		_code = ((_wpLast get3DENAttribute "onActivation")#0);
		_txt = _txt + (toString [13,10])+(toString [13,10]) + format ["[(_group #1),_groupInf,%1,%2,%3,%4,%5,%6,true] call GDC_fnc_lucyTransportReinforcement;",_wpPosList,_wpPosList2,[(speedMode _group),(behaviour (leader _group)),(combatMode _group)],str _condition,_timeout,str _code];
	
	};
	default {
		_txt =  "//Wps non pris en compte";
	};
};
_txt;