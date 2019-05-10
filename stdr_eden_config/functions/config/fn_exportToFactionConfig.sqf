/*
 * Author : Sparfell
 * Export units to faction configs
 * 
 * Parameters
 * 0 - ARRAY of objects : objects selected in 3DEN for instance
 * 1 - STRING (optionnal) : author TAG for use in classes (default="TAG")
 * 2 - STRING (optionnal) : DLC class (default="MyDLC")
 * 3 - STRING (optionnal) : author name (default="Some Random Guy")
 * 4 - NUMBER (optionnal) : export mode : 0= full export including custom bakcpack and weapon classes, 1= export just the unit class (default=0)
 *
 * Return : STRING : the text to past in your config file
*/

params ["_objects",["_tag","TAG"],["_dlc","MyDLC"],["_author","SomeRandomGuy"],["_exportMode",0]];
private [
	"_line","_line1","_line2","_line3","_line4","_tab","_txt","_txtFinal","_txtUnits","_txtBags","_txtWeapon","_countWeapon","_countBag","_countUnit","_scopePrivate","_scopePublic",
	"_mags","_item","_items","_type","_slot","_newClass","_newBackpackClass","_listNewWeaponClass","_dn","_cn","_role","_weapType",
	"_listBagParentClass","_listWeaponParentClass","_listUniformItems","_listVestItems","_listBackpackItems","_listAllItems"
];

_objects = _objects select {_x isKindOf "man"};
_txt = "";
_txtFinal = "";
_txtUnits = "";
_txtBags = "";
_txtWeapon = "";
_newBackpackClass = "";
_listBagParentClass = [];
_listWeaponParentClass = [];
_countUnit = 0;
_countWeapon = 0;
_countBag = 0;
_tab = toString [9];
_line = toString [13,10];
_line1 = _line + _tab;
_line2 = _line1 + _tab;
_line3 = _line2 + _tab;
_line4 = _line3 + _tab;
_scopePrivate = format ["%1scope = 1;%1scopeArsenal = 0;%1author = %3;%1dlc = %2;",_line2,str _dlc,str _author];
_scopePublic = format ["%1scope = 2;%1scopeCurator = 2;",_line2];

{
	_loadout = getUnitLoadout _x;
	_primary = _loadout #0;
	_secondary = _loadout #1;
	_handgun = _loadout #2;
	_uniform = _loadout #3;
	_vest = _loadout #4;
	_backpack = _loadout #5;
	_headgear = _loadout #6;
	_facewear = _loadout #7;
	_bino = _loadout #8;
	_assigneditems = _loadout #9;

	_dn = (_x get3DENAttribute "description")#0;
	_dn = if (_dn == "") then {"My New Unit"} else {_dn};
	_cn = (_x get3DENAttribute "Name")#0;

	_listUniformItems = [];
	_listVestItems = [];
	_listBackpackItems = [];
	_listAllItems = [];
	_listNewWeaponClass = [];

	// Uniform items
	if ((count _uniform) > 0) then {
		{
			_item = _x;
			for "_i" from 1 to (_item#1) do {
				_listUniformItems = _listUniformItems + [(_item#0)];
			};
		} forEach (_uniform#1);
	};
	// Vest items
	if ((count _vest) > 0) then {
		{
			_item = _x;
			for "_i" from 1 to (_item#1) do {
				_listVestItems = _listVestItems + [(_item#0)];
			};
		} forEach (_vest#1);
	};
	// Backpack items
	if ((count _backpack) > 0) then {
		{
			_item = _x;
			for "_i" from 1 to (_item#1) do {
				_listBackpackItems = _listBackpackItems + [(_item#0)];
			};
		} forEach (_backpack#1);
	};

	// An array with all the items transported by the unit
	_mags = [];
	{
		if (count _x > 0) then {
			_mags = _mags + [(_x#4)#0];
		};
	} forEach [_primary,_secondary,_handgun,_bino];
	if (count _primary > 0) then {
		_mags = _mags + [(_primary#5)#0];
	};
	_listAllItems = _mags + _listUniformItems + _listVestItems + _listBackpackItems;

	//Handle unit role
	_role = "";
	if ((_primary#0) iskindof ["Rifle_Long_Base_F",(configFile >> "CfgWeapons")]) then {
		_role = format ["%1//icon = ""iconManMG""; //Is this guy MG ?",_line2]; //TODO comment it back
	};
	if (((_x get3DENAttribute "rank")#0) in ["CORPORAL","SERGEANT"]) then {
		_role = format ["%1icon = ""iconManLeader"";",_line2];
	};
	if (((_x get3DENAttribute "rank")#0) in ["LIEUTENANT","CAPTAIN","MAJOR","COLONEL"]) then {
		_role = format ["%1icon = ""iconManOfficer"";",_line2];
	};
	if ("Medikit" in _listAllItems) then {
		_role = format ["%1icon = ""iconManMedic"";%1picture = ""pictureHeal"";%1attendant = 1;",_line2];
	};
	if ("ToolKit" in _listAllItems) then {
		_role = format ["%1icon = ""iconManEngineer"";%1picture = ""pictureRepair"";%1engineer = 1;%1canDeactivateMines = 1;",_line2];
	};
	_listAllItems = _mags + _listUniformItems + _listVestItems;

	// handle custom backpack classes string
	if ((count _backpack) > 0) then {
		if (count _listBackpackItems > 0) then {
			_countBag = _countBag + 1;
			_listBagParentClass = _listBagParentClass + [_backpack#0];
			_newBackpackClass = (format ["%1_%2_%3",_tag,(_backpack#0),_countBag]);
			_txtBags = _txtBags + (format ["%1class %2: %3%1{%4",_line1,_newBackpackClass,(_backpack#0),_scopePrivate]);
			_mags = _listBackpackItems select {_x isKindOf ["CA_Magazine",(configFile >> "CfgMagazines")]}; // maybe use BIS_fnc_itemType ?
			_items = _listBackpackItems select {_x isKindOf ["ItemCore",(configFile >> "CfgWeapons")]};
			if ((count _mags) > 0) then {
				_txtBags = _txtBags + (format ["%1class TransportMagazines%1{",_line2]);
				{
					_type = _x;
					_count = ({_x == _type} count _mags);
					_txtBags = _txtBags + (format ["%1class _xx_%3%1{%2magazine = ""%3"";%2count = %4;%1};",_line3,_line4,_type,_count]);
				} forEach (_mags arrayIntersect _mags);
				_txtBags = _txtBags + _line2 + "};";
			};
			if ((count _items) > 0) then {
				_txtBags = _txtBags + (format ["%1class TransportItems%1{",_line2]);
				{
					_type = _x;
					_count = ({_x == _type} count _items);
					_txtBags = _txtBags + (format ["%1class _xx_%3%1{%2name = ""%3"";%2count = %4;%1};",_line3,_line4,_type,_count]);
				} forEach (_items arrayIntersect _items);
				_txtBags = _txtBags + _line2 + "};";
			};
			_txtBags = _txtBags +_line1 +"};";
		} else {
			_newBackpackClass = _backpack#0;
		};
	};

	// handle custom weapon classes string
	{
		_weapType = _x;
		if ((count _weapType) > 0) then {
			if ((count (_weapType#1) > 0) OR (count (_weapType#2) > 0) OR (count (_weapType#3) > 0) OR (count (_weapType#6) > 0)) then {
				// Need to create a custom weapon class
				_countWeapon = _countWeapon + 1;
				_listWeaponParentClass = _listWeaponParentClass + [_weapType#0];
				_newClass = (format ["%1_%2_%3",_tag,(_weapType#0),_countWeapon]);
				_txtWeapon = _txtWeapon + (format ["%1class %2: %3%1{%4",_line1,_newClass,(_weapType#0),_scopePrivate]);
				_txtWeapon = _txtWeapon + (format ["%1class LinkedItems%1{",_line2]);
				//Attachements
				// Muzzle attachement
				if (count (_weapType#1) > 0) then {
					_type = _weapType#1;
					_slot = (configProperties [(configFile >> "CfgWeapons" >> (_weapType#0) >> "WeaponSlotsInfo"),"getText (_x >> ""linkProxy"") == ""\A3\data_f\proxies\weapon_slots\MUZZLE"""]);
					if (count _slot > 0) then {
						_slot = [_slot#0] call BIS_fnc_configPath;
						_slot = _slot #((count _slot) - 1);
						_txtWeapon = _txtWeapon + (format ["%1class LinkedItemsMuzzle%1{%2slot = %3;%2item = %4;%1};",_line3,_line4,str _slot,str _type]);
					};
				};
				// Side attachement
				if (count (_weapType#2) > 0) then {
					_type = _weapType#2;
					_slot = (configProperties [(configFile >> "CfgWeapons" >> (_weapType#0) >> "WeaponSlotsInfo"),"getText (_x >> ""linkProxy"") == ""\a3\data_f\proxies\weapon_slots\SIDE"""]);
					if (count _slot > 0) then {
						_slot = [_slot#0] call BIS_fnc_configPath;
						_slot = _slot #((count _slot) - 1);
						_txtWeapon = _txtWeapon + (format ["%1class LinkedItemSide%1{%2slot = %3;%2item = %4;%1};",_line3,_line4,str _slot,str _type]);
					};
				};
				// Optic attachement
				if (count (_weapType#3) > 0) then {
					_type = _weapType#3;
					_slot = (configProperties [(configFile >> "CfgWeapons" >> (_weapType#0) >> "WeaponSlotsInfo"),"getText (_x >> ""linkProxy"") == ""\a3\data_f\proxies\weapon_slots\TOP"""]);
					if (count _slot > 0) then {
						_slot = [_slot#0] call BIS_fnc_configPath;
						_slot = _slot #((count _slot) - 1);
						_txtWeapon = _txtWeapon + (format ["%1class LinkedItemsOptic%1{%2slot = %3;%2item = %4;%1};",_line3,_line4,str _slot,str _type]);
					};
				};
				// Underbarrel attachement
				if (count (_weapType#6) > 0) then {
					_type = _weapType#6;
					_slot = (configProperties [(configFile >> "CfgWeapons" >> (_weapType#0) >> "WeaponSlotsInfo"),"getText (_x >> ""linkProxy"") == ""\a3\data_f_mark\Proxies\Weapon_Slots\UNDERBARREL"""]);
					if (count _slot > 0) then {
						_slot = [_slot#0] call BIS_fnc_configPath;
						_slot = _slot #((count _slot) - 1);
						_txtWeapon = _txtWeapon + (format ["%1class LinkedItemsBipod%1{%2slot = %3;%2item = %4;%1};",_line3,_line4,str _slot,str _type]);
					};
				};
				_txtWeapon = _txtWeapon + _line2 + "};";
				_txtWeapon = _txtWeapon + _line1 + "};";
			} else {
				_newClass = _weapType#0;
			};
			_listNewWeaponClass = _listNewWeaponClass + [_newClass];
		};
	} forEach [_primary,_secondary,_handgun];

	// handle unit strings
	_countUnit = _countUnit + 1;
	if (_cn == "") then {
		_txt = (format ["%1_MyNewUnit_%2",_tag,_countUnit]);
	} else {
		_txt = (format ["%1_%2",_tag,_cn]); // custom classname
	};
	_txtUnits = _txtUnits + (format ["%1class %6: %3_soldier_base%1{%4%2displayName = ""%5"";%7",_line1,_line2,_tag,_scopePublic,_dn,_txt,_role]);
	_txtUnits = _txtUnits + (format ["%1//%2_PREVIEW(%3)",_line2,_tag,_txt]);
	if ((count _uniform) > 0) then {
		_txtUnits = _txtUnits + (format ["%1uniformClass = %2;",_line2,str (_uniform#0)]);
	};
	if ((count _backpack) > 0) then {
		_txtUnits = _txtUnits + (format ["%1backpack = %2;",_line2,str _newBackpackClass]);
	};
	//Linked items
	_txt = [];
	if ((count _vest) > 0) then {
		_txt = _txt + [(_vest#0)];
	};
	{
		if ((count _x) > 0) then {
			_txt = _txt + [_x];
		};
	} forEach [_headgear,_facewear];
	if ((count _assigneditems) > 0) then {
		{
			_txt = _txt + [_x];
		} forEach (_assigneditems select {_x != ""});
	};
	_txt = (str _txt);
	_txt = _txt select [1,(count _txt)-2];
	_txt = "{" + _txt + "}";
	_txtUnits = _txtUnits + (format ["%1linkedItems[] = %2;%1respawnLinkedItems[] = %2;",_line2,_txt]);
	//Weapons 
	_txt = [] + _listNewWeaponClass;
	if (count _bino > 0) then {_txt = _txt + [(_bino#0)];};
	_txt = _txt + ["Throw","Put"];
	_txt = (str _txt);
	_txt = _txt select [1,(count _txt)-2];
	_txt = "{" + _txt + "}";
	_txtUnits = _txtUnits + (format ["%1weapons[] = %2;%1respawnWeapons[] = %2;",_line2,_txt]);
	//Magazines
	_txt = [];
	_mags = _listAllItems select {_x isKindOf ["CA_Magazine",(configFile >> "CfgMagazines")]};
	{
		_txt = _txt + [_x];
	} forEach _mags;
	_txt = (str _txt);
	_txt = _txt select [1,(count _txt)-2];
	_txt = "{" + _txt + "}";
	_txtUnits = _txtUnits + (format ["%1magazines[] = %2;%1respawnMagazines[] = %2;",_line2,_txt]);
	//Items
	_txt = [];
	_items = _listAllItems select {_x isKindOf ["ItemCore",(configFile >> "CfgWeapons")]};
	{
		_txt = _txt + [_x];
	} forEach _items;
	_txt = (str _txt);
	_txt = _txt select [1,(count _txt)-2];
	_txt = "{" + _txt + "}";
	_txtUnits = _txtUnits + (format ["%1Items[] = %2;%1RespawnItems[] = %2;",_line2,_txt]);
	//Close
	_txtUnits = _txtUnits + _line1 + "};";
} forEach _objects;

/* CREATING FINAL TEXT */

_listWeaponParentClass = _listWeaponParentClass arrayIntersect _listWeaponParentClass;
_listBagParentClass = _listBagParentClass arrayIntersect _listBagParentClass;
//Required addons
_txt =  [];
{
	_txt = _txt + (configSourceAddonList (configFile >> "CfgWeapons" >> _x));
} forEach _listWeaponParentClass;
{
	_txt = _txt + (configSourceAddonList (configFile >> "CfgVehicles" >> _x));
} forEach _listBagParentClass;
if (count _txt > 0) then {
	_txtFinal = _txtFinal + (format ["//requiredAddons : %1%2",(_txt arrayIntersect _txt),_line]);
};

// Add Weapon base classes and custom Weapon classes to final string
if ((_countWeapon > 0) && (_exportMode < 1)) then {
	_txtFinal = _txtFinal + (format ["class CfgWeapons%1{",_line]);
	_txt = "";
	{
		_txt = _txt + _line1 + "class " + _x + ";";
	} forEach _listWeaponParentClass;
	_txtFinal = _txtFinal + (format ["%3%2//You should rename your custom weapon classes.%4%1};",_line,_line1,_txt,_txtWeapon]);
};
if (_exportMode < 1) then {_txtFinal = format ["%2%1%1class CfgVehicles%1{",_line,_txtFinal];};
// Add backpack base classes and custom backpack classes to final string
if ((_countBag > 0) && (_exportMode < 1)) then {
	_txt = "";
	{
		_txt = _txt + _line1 + "class " + _x + ";";
	} forEach _listBagParentClass;
	_txtFinal = _txtFinal + (format ["%2%1//You should rename your custom backpack classes.%3",_line1,_txt,_txtBags]);
};
// Add Unitclass to final string
if (_exportMode < 1) then {
	_txtFinal = _txtFinal + format ["%1#define %2_PREVIEW(x)%3editorPreview = \Path\To\Picture\data\preview\##x##.jpg",_line1,_tag,_tab];
	_txtFinal = _txtFinal + _line1 + "class B_Soldier_base_F;";
	_txtFinal = _txtFinal + (format ["%1class %4_soldier_base : B_Soldier_base_F%1{%3%2side = 1;%5%2faction = ""%4_MyFaction"";%5%2identityTypes[] = {""LanguageENG_F"",""Head_NATO"",""G_NATO_default""};%5%2icon = ""iconMan"";%1};",_line1,_line2,_scopePrivate,_tag," //Modify"]);
};
_txtFinal = _txtFinal + _txtUnits;
if (_exportMode < 1) then {_txtFinal = _txtFinal + _line + "};" + _line;};
copyToClipboard _txtFinal;
_txtFinal;