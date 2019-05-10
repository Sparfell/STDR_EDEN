class CfgPatches
{
	class stdr_eden_various
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.10;
		requiredAddons[] = {"3DEN","A3_Weapons_F_Items","ace_medical"};
	};
};

class CfgWeapons
{
	class ItemCore;
	class Medikit: ItemCore
	{
		scopeArsenal = 2;
		ace_arsenal_hide = 0;
	};
	class FirstAidKit: ItemCore
	{
		scopeArsenal = 2;
		ace_arsenal_hide = 0;
	};
};