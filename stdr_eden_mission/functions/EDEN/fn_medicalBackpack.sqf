/*
 * add default medic equipement in the backpack of the selected units
 * 
 * Parameters
 * 0 - ARRAY of objects : objects selected in 3DEN for instance
 *
 * Return : Nothing
*/

params ["_objects"];

{
	_x addItemToBackpack "ACE_personalAidKit";
	_x addItemToBackpack "ACE_surgicalKit";
	for "_i" from 1 to 2 do {_x addItemToBackpack "ACE_salineIV";};
	for "_i" from 1 to 2 do {_x addItemToBackpack "ACE_salineIV_250";};
	for "_i" from 1 to 2 do {_x addItemToBackpack "ACE_salineIV_500";};
	for "_i" from 1 to 4 do {_x addItemToBackpack "ACE_tourniquet";};
	for "_i" from 1 to 8 do {_x addItemToBackpack "ACE_morphine";};
	for "_i" from 1 to 4 do {_x addItemToBackpack "ACE_epinephrine";};
	for "_i" from 1 to 15 do {_x addItemToBackpack "ACE_packingBandage";};
	for "_i" from 1 to 15 do {_x addItemToBackpack "ACE_fieldDressing";};
	for "_i" from 1 to 10 do {_x addItemToBackpack "ACE_elasticBandage";};
	for "_i" from 1 to 10 do {_x addItemToBackpack "ACE_quikclot";};
} forEach _objects;