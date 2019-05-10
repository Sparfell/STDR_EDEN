class CfgPatches
{
	class stdr_eden_config
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.10;
		requiredAddons[] = {"3DEN"};
	};
};

class CfgFunctions
{
	class STDR
	{
		class EDEN_config
		{
			file = "stdr_eden\stdr_eden_config\functions\config";
			class exportToFactionConfig {};
			class exportToGroupConfig {};
		};
	};
};

class ctrlControlsGroupNoScrollbars;
class ctrlTree;
class ctrlMenu;
class ctrlMenuStrip;
class display3DEN
{
	class Controls
	{
		class MenuStrip: ctrlMenuStrip
		{
			class Items
			{
				class Tools
				{
					items[] += {"STDR_Tools_config"};
				};
				class STDR_Tools_config
				{
					text = "STDR config Tools";
					picture = "\stdr_eden\stdr_eden_config\data\gdc_icon_32.paa";
					items[] = {"STDR_exportToFactionConfig","STDR_exportToFactionConfigCUP","STDR_exportToFactionConfigCPC"};
				};
				class STDR_exportToFactionConfig
				{
					text = "Export unit(s) as config";
					action = "[(get3DENSelected ""object"")] call STDR_fnc_exportToFactionConfig;";
				};
				class STDR_exportToFactionConfigCUP
				{
					text = "Export unit(s) as config (CUP)";
					action = "[(get3DENSelected ""object""),""CUP"",""CUP_Units"",""Community Upgrade Project""] call STDR_fnc_exportToFactionConfig;";
				};
				class STDR_exportToFactionConfigCPC
				{
					text = "Export unit(s) as config (CPC)";
					action = "[(get3DENSelected ""object""),""CPC"",""CPC_Factions_CUP"",""CPC Faction""] call STDR_fnc_exportToFactionConfig;";
				};
			};
		};
	};
	class ContextMenu: ctrlMenu
	{
		class Items
		{
			class Log
			{
				items[] += {"STDR_exportToFactionConfig","STDR_exportToFactionConfigCUP","STDR_exportToFactionConfigCPC","STDR_exportToCfgGroups","STDR_exportToCfgGroupsCUP","STDR_exportToCfgGroupsCPC"};
			};
			class STDR_exportToFactionConfig
			{
				text = "Export unit(s) as config";
				action = "[(get3DENSelected ""object""),""TAG"",""MyDLC"",""MyAuthor"",1] call STDR_fnc_exportToFactionConfig;";
				conditionShow = "selectedObject * hoverObject";
				picture = "\stdr_eden\stdr_eden_config\data\gdc_icon_32.paa";
			};
			class STDR_exportToFactionConfigCUP
			{
				text = "Export unit(s) as config (CUP)";
				action = "[(get3DENSelected ""object""),""CUP"",""CUP_Units"",""Community Upgrade Project"",1] call STDR_fnc_exportToFactionConfig;";
				conditionShow = "selectedObject * hoverObject";
				picture = "\stdr_eden\stdr_eden_config\data\gdc_icon_32.paa";
			};
			class STDR_exportToFactionConfigCPC
			{
				text = "Export unit(s) as config (CPC)";
				action = "[(get3DENSelected ""object""),""CPC"",""CPC_Factions_CUP"",""CPC Faction"",1] call STDR_fnc_exportToFactionConfig;";
				conditionShow = "selectedObject * hoverObject";
				picture = "\stdr_eden\stdr_eden_config\data\gdc_icon_32.paa";
			};
			class STDR_exportToCfgGroups
			{
				text = "Export group(s) as CfgGroups";
				action = "[(get3DENSelected ""group""),""TAG""] call STDR_fnc_exportToGroupConfig;";
				conditionShow = "selectedObject * hoverGroup";
				picture = "\stdr_eden\stdr_eden_config\data\gdc_icon_32.paa";
			};
			class STDR_exportToCfgGroupsCUP
			{
				text = "Export group(s) as CfgGroups (CUP)";
				action = "[(get3DENSelected ""group""),""CUP""] call STDR_fnc_exportToGroupConfig;";
				conditionShow = "selectedObject * hoverGroup";
				picture = "\stdr_eden\stdr_eden_config\data\gdc_icon_32.paa";
			};
			class STDR_exportToCfgGroupsCPC
			{
				text = "Export group(s) as CfgGroups (CPC)";
				action = "[(get3DENSelected ""group""),""CPC""] call STDR_fnc_exportToGroupConfig;";
				conditionShow = "selectedObject * hoverGroup";
				picture = "\stdr_eden\stdr_eden_config\data\gdc_icon_32.paa";
			};
		};
	};
};

class Cfg3DEN
{
	class Tutorials
	{
		class STDR_exportToConfig
		{
			displayName = "Export to config";
			class Sections
			{
				class STDR_exportToConfig_1
				{
					displayName = "Units to faction config";
					class Steps
					{
						class Text1
						{
							text = "This tool allows you to export units loadouts to config format.<br/><br/>First you need to select the units you want to export.<br/><br/>And then you have to use one of the two following options.";
						};
						class Text2
						{
							text = "<%2>1)<%3> In the top menu bar go to ""Tools > STDR config Tools"" and select ""Export unit(s) as config"". This will create a complete export of the selected units. It means it will also export custom backpack and weapon classes if the units need them, as well as a parent base class for your units.";
							highlight = 120;
						};
						class Text3
						{
							text = "<%2>2)<%3> Open the contextual menu hover a unit, go to ""Log"" and select ""Export unit(s) as config"". This will export only the unit configs without custom backpack and weapon classes (even if the unit need them) and without the parent base class of your units.";
						};
						class Text4
						{
							text = "<t underline='1'><%2>Name and classname customization<%3></t><br/><br/>- You can attribute a classname to the unit by changing the unit's <%2>""Name""<%3>.<br/><br/>- You can attribute a displayName to the unit by changing the unit's <%2>""Description""<%3>.";
						};
						class Text5
						{
							text = "<t underline='1'><%2>Role customization<%3></t><br/><br/>- If a unit rank is <%2>CORPORAL<%3> or higher it will be exported as a leader.<br/><br/>- If a unit rank is <%2>LIEUTENANT<%3> or higher it will be exported as an officer.<br/><br/>- If a unit has a <%2>Medikit<%3> it will be exported as a medic.<br/><br/>- If a unit has a <%2>Toolkit<%3> it will be exported as an engineer.";
						};
					};
				};
				class STDR_exportToConfig_2
				{
					displayName = "Groups to CfgGroups";
					class Steps
					{
						class Text1
						{
							text = "This tool allows you to export group composition to CfgGroups config format.<br/><br/>In order to use it, open the contextual menu hover a group, go to ""Log"" and select ""Export group(s) as CfgGroups"".";
						};
					};
				};
			};
		};
	};
};