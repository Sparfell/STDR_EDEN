class CfgPatches
{
	class stdr_eden_mission
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.10;
		requiredAddons[] = {"3DEN"};
	};
	class stdr_eden: stdr_eden_mission {};
};

class CfgFunctions
{
	class STDR
	{
		class EDEN
		{
			file = "stdr_eden\stdr_eden_mission\functions\EDEN";
			class defaultLoadout {};
			class conditionOfPresence {};
			class 3denCalculateDistance {};
			class createzeusmodule {};
		};
		class LUCY
		{
			file = "stdr_eden\stdr_eden_mission\functions\LUCY";
			class 3denLucyExportStatic {};
			class 3denLucyExportGroupInf {};
			class 3denLucyExportGroupVeh {};
			class 3denLucyExportWaypoints {};
			class 3denLucyExportGlobal {};
			class 3denLucyConvertFormation {};
			class 3denLucyConvertSpeed {};
			class 3denLucyConvertSide {};
			class 3denLucyGetGroupBehaviour {};
			class 3denLucyPluto {};
			class getDirFromLocation {};
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
					items[] += {"STDR_Tools"};
				};
				class STDR_Tools
				{
					text = "Outils STDR";
					picture = "\stdr_eden\stdr_eden_mission\data\gdc_icon_32.paa";
					items[] = {"STDR_exportToLucy","STDR_exportOpforToLucy","STDR_exportIndependentToLucy","STDR_exportBluforToLucy","STDR_createzeusmodule"};
				};
				class STDR_exportToLucy
				{
					text = "Export to LUCY";
					action = "[1] call STDR_fnc_3denLucyExportGlobal;";
				};
				class STDR_exportOpforToLucy
				{
					text = "Export OPFOR to LUCY";
					action = "[1,""opfor""] call STDR_fnc_3denLucyExportGlobal;";
				};
				class STDR_exportIndependentToLucy
				{
					text = "Export INDEP to LUCY";
					action = "[1,""independent""] call STDR_fnc_3denLucyExportGlobal;";
				};
				class STDR_exportBluforToLucy
				{
					text = "Export BLUFOR to LUCY";
					action = "[1,""blufor""] call STDR_fnc_3denLucyExportGlobal;";
				};
				class STDR_createzeusmodule
				{
					text = "Create Debug Zeus Module";
					action = "[] call STDR_fnc_createzeusmodule;";
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
				items[] += {"STDR_exportToLucy","STDR_exportLayerToLucy","STDR_calculateDistance"};
			};
			class STDR_exportToLucy
			{
				text = "Export to LUCY";
				action = "[1] call STDR_fnc_3denLucyExportGlobal;";
				conditionShow = "selectedObject * hoverGroup";
				picture = "\stdr_eden\stdr_eden_mission\data\gdc_icon_32.paa";
			};
			/*
			class STDR_exportToLucy_2
			{
				text = "Export to LUCY (variant)";
				action = "[1] call STDR_fnc_3denLucyExportGlobal;";
				conditionShow = "selectedObject * hoverGroup";
				picture = "\stdr_eden\stdr_eden_mission\data\gdc_icon_32.paa";
			};
			*/
			class STDR_exportLayerToLucy
			{
				text = "Export Layer to LUCY";
				action = "do3DENAction ""SelectLayerChildren""; [1] call STDR_fnc_3denLucyExportGlobal;";
				conditionShow = "hoverLayer";
				picture = "\stdr_eden\stdr_eden_mission\data\gdc_icon_32.paa";
			};
			class STDR_calculateDistance
			{
				text = "Calculate distance";
				action = "[] call STDR_fnc_3denCalculateDistance;";
				conditionShow = "true";
				picture = "\stdr_eden\stdr_eden_mission\data\gdc_icon_32.paa";
			};
			class Edit
			{
				items[] += {"STDR_defaultLoadout"};
			};
			class STDR_defaultLoadout
			{
				text = "Add default loadout to selected units";
				action = "[(get3DENSelected ""object"")] call STDR_fnc_defaultLoadout;";
				conditionShow = "selectedObject * hoverObject";
				picture = "\stdr_eden\stdr_eden_mission\data\gdc_icon_32.paa";
			};
		};
	};
};

class Cfg3DEN
{
	class Tutorials
	{
		class STDR_exportToLucy
		{
			displayName = "Export 3DEN to LUCY";
			class Sections
			{
				class STDR_exportToLucy_intro
				{
					displayName = "Introduction";
					class Steps
					{
						class Text1
						{
							text = "Pour exporter les unités contenues dans la mission, il y a trois méthodes :<br/><br/><%2>1)<%3> Dans le menu, <%2>""Outils > Outils STDR""<%3> vous trouverez un bouton nommé <%2>Export to Lucy<%3>. Il permet d'exporter le ou les groupes sélectionnés ou bien tous les groupes de la mission si aucun groupe n'est sélectionné.<br/><br/><%2>2)<%3> Via le <%2>menu contextuel<%3> lorsque vous êtes au dessus d'un groupe pour exporter le ou les groupes sélectionnés.<br/><br/><%2>3)<%3> Via le menu contextuel lorsque vous êtes au dessus d'un <%2>Layer<%3> afin de n'exporter que les groupes de ce layer (ne fonctionne qu'avec les layers crées par le MM).";
							highlight = 120;
						};
						class Text2
						{
							text = "<t underline='1'><%2>A savoir :<%3></t><br/><br/>Le contenu exporté est copié dans le presse papier.<br/><br/>Lors d'un export de toute la mission, les unités jouables sont toujours ignorées.<br/><br/>La condition de présence des groupes exportés devient ""false"". Cela signifie que les groupes exportés n'apparaissent pas dans la mission une fois celle-ci lancée, il faut donc les faire spawn avec le script obtenu.";
						};
					};
				};
				class STDR_exportToLucy_patrol
				{
					displayName = "Groupe en patrouille waypoints";
					class Steps
					{
						class Text1
						{
							text = "Si le dernier WP d'un groupe est de type <%2>CYCLE<%3> (réitérer), le groupe fera une patrouille perpétuelle qui correspond au cheminement définit par ses WPs.<br/><br/>L'attitude (comportement, vitesse, formation) du groupe pendant la patrouille dépend de celle définie dans les attributs du groupe.";
						};
					};
				};
				class STDR_exportToLucy_patrolArea
				{
					displayName = "Groupe en patrouille dans une zone";
					class Steps
					{
						class Text1
						{
							text = "Si le groupe n'a qu'un WP, qu'il est de type ""MOVE"" et qu'il est proche d'un marqueur de zone (10m) alors le groupe fera une patrouille perpétuelle dans la zone du marqueur.<br/><br/>L'attitude (comportement, vitesse, formation) du groupe pendant la patrouille dépend de celle définie dans les attributs du groupe.";
						};
					};
				};
				class STDR_exportToLucy_renfort
				{
					displayName = "Renfort";
					class Steps
					{
						class Text1
						{
							text = "Si le dernier WP d'un groupe est de type <%2>SAD<%3> (Seek and Destroy) ou <%2>Hold<%3>, le groupe sera considéré comme un groupe de renfort.<br/><br/>Le mouvement du groupe de renfort s'éffectue en 2 phases :<br/>- <%2>L'approche<%3> : tous les WPs jusqu'à l'avant dernier.<br/>- <%2>L'assaut<%3> : mouvement qui va de l'avant dernier au dernier WP.<br/><br/>Note : Si le dernier WP est de type <%2>Hold<%3> il sera de type <%2>MOVE<%3> dans le script. Ceci peut être utile si vous ne voulez pas que le groupe bouge dans tous les sens une fois arrivé à destination.";
						};
						class Text2
						{
							text = "L'attitude (comportement, vitesse, formation) de la <%2>phase d'approche<%3> est définie dans le 1er WP du groupe.<br/><br/>Il est possible de donner une conditionet/ou un timer de départ pour le renfort. Pour cela, il faut utiliser le champs ""condition"" et les champs ""timer"" du 1er WP du groupe.";
						};
						class Text3
						{
							text = "L'attitude (comportement, vitesse, formation) de la <%2>phase d'assaut<%3> est définie dans le dernier WP du groupe.<br/><br/>Il est possible d'exécuter du code à lorsque le groupe arrive sur son dernier WP. Pour cela, il faut utiliser le champs ""Sur Activation"" du dernier WP du groupe.<br/><br/>Si le dernier WP du groupe est proche (10m) d'un marqueur de zone alors le groupe va patrouiller dans la zone du marqueur une fois qu'il a atteint son dernier WP.";
						};
					};
				};
				class STDR_exportToLucy_renfortTransport
				{
					displayName = "Renfort transporté par véhicule";
					class Steps
					{
						class Text1
						{
							text = "<t underline='1'><%2>Groupe du véhicule de transport :<%3></t><br/><br/>Si le groupe a au moins un WP de type <%2>Transport Unload<%3> le groupe va se servir de son véhicule pour transporter un groupe de renfort.<br/><br/>L'attitude (comportement, vitesse, formation) du groupe pendant son trajet dépend de celle définie dans les attributs du groupe.<br/><br/>Il est possible de donner une condition et/ou un timer de départ pour le renfort. Pour cela, il faut utiliser le champs ""condition"" et les champs ""timer"" du 1er WP du groupe.<br/><br/>Il est possible d'exécuter du code lorsque le groupe arrive sur son WP ""Transport Unload"". Pour cela, il faut utiliser le champs ""Sur Activation"" de ce WP.<br/><br/>Tous les WP qui sont après le WP ""Transport Unload"" sont considérés comme l'itinéraire de retour du véhicule de transport.";
						};
						class Text2
						{
							text = "<t underline='1'><%2>Groupe transporté :<%3></t><br/><br/>Pour désigner le groupe transporté, le leader de ce groupe doit être synchronisé avec le véhicule.<br/><br/>Il est possible de donner des WPs au groupe transporté (patrouille, renfort, etc) ceux-ci ne seront effécutés que lorsque le groupe aura été débarqué sur le WP ""Transport Unload"" du véhicule.";
						};
					};
				};
				class STDR_exportToLucy_Pluto
				{
					displayName = "Intégration de PLUTO";
					class Steps
					{
						class Text1
						{
							text = "Vous pouvez donner un ordre PLUTO à un groupe.<br/><br/>Dans les attributs du groupe remplissez le cadre ""Init"" avec l'une des options suivantes :<br/><br/>- <%2>pluto_qrf;<%3><br/>- <%2>pluto_arty;<%3><br/>- <%2>pluto_ignore;<%3><br/><br/>Vous pouvez aussi définir les autres paramètres de PLUTO en écrivant par exemple :<br/><%2>pluto_qrf;pluto_qrfrange=2500;<%3><br/>ou<br/><%2>pluto_arty;pluto_artyrange=""markername"";pluto_artyrounds=[4,6,8];<%3><br/>ou<br/><%2>pluto_revelrange=3000;<%3>";
						};
					};
				};
				/*
				class STDR_exportToLucy_template
				{
					displayName = "Template";
					class Steps
					{
						class Text1
						{
							text = "";
						};
						class Text2
						{
							text = "";
						};
					};
				};
				*/
			};
		};
	};
};


/*
class CfgNonAIVehicles
{
	class EmptyDetector;
	class STDR_EmptyDetector_RadioEndMission: EmptyDetector
	{
		displayName = "Trigger radio fin de mission";
		class AttributeValues
		{
			size2[] = {0,0};
			size3[] = {0,0,-1};
			text = "Couper la mission";
			ActivationBy = "ALPHA";
			onActivation = "[""end1"",true,4] call BIS_fnc_endMission;";
		};
	};
};*/