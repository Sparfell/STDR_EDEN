/*
 * set default loadout to the selected units
 * 
 * Parameters
 * 0 - ARRAY of objects : objects selected in 3DEN for instance
 *
 * Return : Nothing
*/

params ["_objects"];

{
	_x setUnitLoadout [[],[],[],["U_I_CombatUniform",[["ACE_fieldDressing",4],["ACE_tourniquet",1],["ACE_EarPlugs",1],["ACE_Flashlight_MX991",1],["ACRE_PRC343",1]]],[],[],"","",[],["ItemMap","","","ItemCompass","ItemWatch",""]];
} forEach _objects;