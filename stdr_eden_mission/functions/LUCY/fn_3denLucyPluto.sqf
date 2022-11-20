params ["_group","_groupname"];
private ["_string","_stringout","_index"];

_stringout = "";
{
	_string = _x;
	if ((_string find "=") == -1) then {
	switch (true) do {
		// Orders
		case ((_string find "pluto_qrf") != -1): {
			_stringout = _stringout + format ["%1 setVariable [""PLUTO_ORDER"",""QRF""];",_groupname];
		};
		case ((_string find "pluto_arty") != -1): {
			_stringout = _stringout + format ["%1 setVariable [""PLUTO_ORDER"",""ARTY""];",_groupname];
		};
		case ((_string find "pluto_ignore") != -1): {
			_stringout = _stringout + format ["%1 setVariable [""PLUTO_ORDER"",""IGNORE""];",_groupname];
		};
		default {};
	};
	} else {
	switch (true) do {
		//Reveal range
		case ((_string find "pluto_revealrange") != -1): {
			_index = (_string find "=");
			_stringout = _stringout + format ["%1 setVariable [""PLUTO_REVEALRANGE"",%2];",_groupname,_string select [_index + 1, (count _string) -_index]];
		};
		//sensor range
		case ((_string find "pluto_sensorrange") != -1): {
			_index = (_string find "=");
			_stringout = _stringout + format ["%1 setVariable [""PLUTO_SENSORRANGE"",%2];",_groupname,_string select [_index + 1, (count _string) -_index]];
		};
		//QRF parameters
		case ((_string find "pluto_qrfrange") != -1): {
			_index = (_string find "=");
			_stringout = _stringout + format ["%1 setVariable [""PLUTO_QRFRANGE"",%2];",_groupname,_string select [_index + 1, (count _string) -_index]];
		};
		case ((_string find "pluto_qrftimeout") != -1): {
			_index = (_string find "=");
			_stringout = _stringout + format ["%1 setVariable [""PLUTO_QRFTIMEOUT"",%2];",_groupname,_string select [_index + 1, (count _string) -_index]];
		};
		case ((_string find "pluto_qrfdelay") != -1): {
			_index = (_string find "=");
			_stringout = _stringout + format ["%1 setVariable [""PLUTO_QRFDELAY"",%2];",_groupname,_string select [_index + 1, (count _string) -_index]];
		};
		//ARTY parameters
		case ((_string find "pluto_artyrange") != -1): {
			_index = (_string find "=");
			_stringout = _stringout + format ["%1 setVariable [""PLUTO_ARTYRANGE"",%2];",_groupname,_string select [_index + 1, (count _string) -_index]];
		};
		case ((_string find "pluto_artytimeout") != -1): {
			_index = (_string find "=");
			_stringout = _stringout + format ["%1 setVariable [""PLUTO_ARTYTIMEOUT"",%2];",_groupname,_string select [_index + 1, (count _string) -_index]];
		};
		case ((_string find "pluto_artyrounds") != -1): {
			_index = (_string find "=");
			_stringout = _stringout + format ["%1 setVariable [""PLUTO_ARTYROUNDS"",%2];",_groupname,_string select [_index + 1, (count _string) -_index]];
		};
		case ((_string find "pluto_artydelay") != -1): {
			_index = (_string find "=");
			_stringout = _stringout + format ["%1 setVariable [""PLUTO_ARTYDELAY"",%2];",_groupname,_string select [_index + 1, (count _string) -_index]];
		};
		case ((_string find "pluto_artyerror") != -1): {
			_index = (_string find "=");
			_stringout = _stringout + format ["%1 setVariable [""PLUTO_ARTYERROR"",%2];",_groupname,_string select [_index + 1, (count _string) -_index]];
		};
		case ((_string find "pluto_artyammotype") != -1): {
			_index = (_string find "=");
			_stringout = _stringout + format ["%1 setVariable [""PLUTO_ARTYAMMOTYPE"",%2];",_groupname,_string select [_index + 1, (count _string) -_index]];
		};
		default {};
	};
	};
} forEach ((tolower ((_group get3DENAttribute "Init")#0)) splitString "; ");
_stringout;