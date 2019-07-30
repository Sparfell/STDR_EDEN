/*
 * Passer la condition de présence à false dans 3DEN
 * 
 * Parameters
 * 0 - ARRAY of OBECTS : group selected in 3DEN for instance
 *
*/
params ["_objects"];
{
	_x set3DENAttribute ["presenceCondition","false"];
} forEach _objects;