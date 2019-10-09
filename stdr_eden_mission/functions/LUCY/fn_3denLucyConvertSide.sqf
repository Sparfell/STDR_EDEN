params ["_side"];
private _result = switch (str _side) do {
	case "WEST" : {"blufor"};
	case "GUER" : {"independent"};
	case "EAST";
	default {"opfor"};
};
_result;
