
params ["_number"];
private _string = switch (_number) do {
	case 1 : {"WEDGE"};
	case 2 : {"VEE"};
	case 3 : {"LINE"};
	case 4 : {"COLUMN"};
	case 5 : {"FILE"};
	case 6 : {"STAG COLUMN"};
	case 7 : {"ECH LEFT"};
	case 8 : {"ECH RIGHT"};
	case 9 : {"DIAMOND"};
	case 0;
	default {"NO CHANGE"};
};
_string;