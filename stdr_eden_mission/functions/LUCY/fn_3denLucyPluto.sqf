params ["_group"];
private ["_string"];

_string = tolower ((_group get3DENAttribute "Init")#0);
_string = _string select [5,((count _string) -6)];
_string = switch (_string) do {
	case "pluto_qrf" : {
		"setVariable [""PLUTO_ORDER"",""QRF""];"
	};
	case "pluto_arty" : {
		"setVariable [""PLUTO_ORDER"",""ARTY""];"
	};
	case "pluto_ignore" : {
		"setVariable [""PLUTO_ORDER"",""IGNORE""];"
	};
	default {""};
};
_string;