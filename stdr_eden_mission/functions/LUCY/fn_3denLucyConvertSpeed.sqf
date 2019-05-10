params ["_number"];
private _string = switch (_number) do {
	case 1 : {"LIMITED"};
	case 2 : {"NORMAL"};
	case 3 : {"FULL"};
	case 0;
	default {"UNCHANGED"};
};
_string;