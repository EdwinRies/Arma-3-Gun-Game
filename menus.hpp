#define CT_STATIC 0
#define CT_BUTTON 1
#define CT_EDIT 2
#define CT_SLIDER 3
#define CT_COMBO 4
#define CT_LISTBOX 5
#define CT_TOOLBOX 6
#define CT_CHECKBOXES 7
#define CT_PROGRESS 8
#define CT_HTML 9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT 11
#define CT_TREE 12
#define CT_STRUCTURED_TEXT 13
#define CT_CONTEXT_MENU 14
#define CT_CONTROLS_GROUP 15
#define CT_SHORTCUTBUTTON 16
#define CT_XKEYDESC 40
#define CT_XBUTTON          41
#define CT_XLISTBOX 42
#define CT_XSLIDER 43
#define CT_XCOMBO 44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT 80
#define CT_OBJECT_ZOOM 81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK 98
#define CT_ANIMATED_USER 99
#define CT_MAP              100
#define CT_MAP_MAIN 101
#define CT_LISTNBOX 102
#define CT_ITEMSLOT         103
#define CT_CHECKBOX         77 //Arma 3

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0c

#define ST_TYPE           0xF0
#define ST_SINGLE         0
#define ST_MULTI          16
#define ST_TITLE_BAR      32
#define ST_PICTURE        48
#define ST_FRAME          64
#define ST_BACKGROUND     80
#define ST_GROUP_BOX      96
#define ST_GROUP_BOX2     112
#define ST_HUD_BACKGROUND 128
#define ST_TILE_PICTURE   144 //tileH and tileW params required for tiled image
#define ST_WITH_RECT      160
#define ST_LINE           176

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200 // this style works for CT_STATIC in conjunction with ST_MULTI
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           1024

#define SL_TEXTURES       0x10

// progress bar 
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

#define FontM             "EtelkaNarrowMediumPro" // The standard font in Arma 3 is "PuristaMedium"

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// MessageBox styles
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4

/////////////////////////////////GUN GAME//////////////////////////////////////
#define GG_MainBGColor {0.102, 0.134, 0.312, 0.3}
#define GG_MainTxtColor {1,1,1,1}
#define GG_MainFrameColor {0.1,0.3,1,1}

#define GG_H1BGColor {0.151, 0.588, 0.901, 0.8}
#define GG_H1TxtColor {1,1,1,1}
#define GG_H1FrameColor {0.1,0.3,1,1}

#define GG_CountDownBGColor {0.785,0.263,0.107}
#define GG_CountDownTxtColor {1,1,1,1}
#define GG_CountDownFrameColor {0.1,0.3,0,1}

#define GG_ListBGColor {0,0,0,0.6}
#define GG_ListSelColor {0,0.2,0.2,0.8}
#define GG_ListSelColor2 {0.2,0.2,0,0.8}

#define GG_LabelBGColor {0,0,0,0.6}
#define GG_LabelTxtColor {1,1,1,1}
#define GG_LabelFrameColor {0,0,0,0.1}

class GG_MainContainer
{
	idc = -1;
	type = CT_STATIC;
	colorBackground[] = GG_MainBGColor; 
	colorText[] = GG_MainTxtColor;
	colorFrame[] = GG_MainFrameColor; 
	text = "";
	style = ST_BACKGROUND;
	font = FontM;
	sizeEx = 0.1;
	x = safezoneX;
	y = safezoneY;
	w = safezoneW;
	h = safezoneH;
};

class GG_H1
{
	idc = -1;
	moving = true;
	type = CT_STATIC;
	colorBackground[] = GG_H1BGColor; 
	colorText[] = GG_H1TxtColor;
	colorFrame[] = GG_H1FrameColor; 
	text = "Header";
	style = ST_CENTER;
	font = FontM;
	sizeEx = 0.05;
	x = safezoneX;
	y = safezoneY;
	w = safezoneW;
	h = 0.05 * safezoneH;
};

class GG_CountDown
{
	idc = 60;
	type = CT_STATIC;
	colorBackground[] = GG_CountDownBGColor; 
	colorText[] = GG_CountDownTxtColor;
	colorFrame[] = GG_CountDownFrameColor; 
	text = "CountDown";
	style = ST_CENTER;
	font = FontM;
	sizeEx = 0.05;
	x = safezoneX + (0.9 * safezoneW);
	y = safezoneY;
	w = 0.1 * safezoneW;
	h = 0.05 * safezoneH;
};

class GG_LISTBOX
{
	access = 0; 
	idc = -1;
	type = CT_LISTBOX;
	style = ST_LEFT + LB_TEXTURES;
	blinkingPeriod = 0;
	x = safezoneX;
	y = safezoneY + (0.1 * safezoneH);
	w = 0.3 * safezoneW;
	h = 0.4 * safezoneH;

	colorBackground[] = GG_MainBGColor;
	colorSelectBackground[] = GG_ListSelColor;
	colorSelectBackground2[] = GG_ListSelColor2;

	sizeEx = 0.04;
	font = FontM;
	shadow = 0;
	colorText[] = {1,1,1,1};
	colorDisabled[] = {1,1,1,0.5};
	colorSelect[] = {1,1,1,1};
	colorSelect2[] = {1,1,1,1};
	colorShadow[] = {0,0,0,0.5};

	pictureColor[] = {1,1,1,1};
	pictureColorSelect[] = {1,1,1,1};
	pictureColorDisabled[] = {1,1,1,1};
	
	colorPicture[] = {1,1,1,1};
	colorPictureSelected[] = {1,1,1,1};
	colorPictureDisabled[] = {1,1,1,1};

	tooltip = "ListBox";
	tooltipColorShade[] = {0,0,0,1};
	tooltipColorText[] = {1,1,1,1};
	tooltipColorBox[] = {1,1,1,1};

	period = 1;

	rowHeight = 0.06;
	itemSpacing = 0;
	maxHistoryDelay = 1;
	canDrag = 0;

	soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1};


	class ListScrollBar 
	{
		width = 0.05;
		height = 0.3;
		scrollSpeed = 0.01;

		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";

		color[] = {1,1,1,1};
	};
};

class GG_Label
{
	idc = -1;
	x = 0;
	y = (0.05 * safezoneH) + safezoneY;
	w = 0.3 * safezoneW;
	h = 0.05 * safezoneH;
	type = CT_STATIC;
	colorBackground[] = GG_LabelBGColor; 
	colorText[] = GG_LabelTxtColor;
	colorFrame[] = GG_LabelFrameColor; 
	text = "Label";
	style = ST_CENTER;
	font = FontM;
	sizeEx = 0.05;
};

class GG_Button 
{ 
	type = CT_BUTTON; 
	style = ST_CENTER; 
	font = FontM; 
	sizeEx = 0.04; 
	colorText[] = {0,0,0,1}; 
	colorDisabled[] = {0.3,0.3,0.3,1}; 
	colorBackground[] = {0.8,0.8,0.8,1}; 
	colorBackgroundDisabled[] = {0.6,0.6,0.6,1}; 
	colorBackgroundActive[] = {0.8,0.8,1,1}; 
	offsetX = 0.004; 
	offsetY = 0.004; 
	offsetPressedX = 0.002; 
	offsetPressedY = 0.002; 
	colorFocused[] = {0,0,0,1}; 
	colorShadow[] = {1,1,1,0}; 
	shadow = 0; 
	colorBorder[] = {0,0,0,1}; 
	borderSize = 0; 
	soundEnter[] = {"",0.1,1}; 
	soundPush[] = {"",0.1,1}; 
	soundClick[] = {"",0.1,1}; 
	soundEscape[] = {"",0.1,1}; 
};

class RscMapControl 
{
	access = 0;
	alphaFadeEndScale = 2;
	alphaFadeStartScale = 2;
	colorBackground[] = {0.969,0.957,0.949,0.4};
	colorCountlines[] = {0.572,0.354,0.188,0.25};
	colorCountlinesWater[] = {0.491,0.577,0.702,0.3};
	colorForest[] = {0.624,0.78,0.388,0.5};
	colorForestBorder[] = {0,0,0,0};
	colorGrid[] = {0.1,0.1,0.1,0.4};
	colorGridMap[] = {0.1,0.1,0.1,0.4};
	colorInactive[] = {1,1,1,0.5};
	colorLevels[] = {0.286,0.177,0.094,0.3};
	colorMainCountlines[] = {0.572,0.354,0.188,0.3};
	colorMainCountlinesWater[] = {0.491,0.577,0.702,0.4};
	colorMainRoads[] = {0.9,0.5,0.3,0.7};
	colorMainRoadsFill[] = {1,0.6,0.4,0.7};
	colorNames[] = {0.1,0.1,0.1,0.9};
	colorOutside[] = {0,0,0,0.7};
	colorPowerLines[] = {0.1,0.1,0.1,0.8};
	colorRailWay[] = {0.8,0.2,0,0.8};
	colorRoads[] = {0.7,0.7,0.7,0.8};
	colorRoadsFill[] = {1,1,1,0.8};
	colorRocks[] = {0,0,0,0.3};
	colorRocksBorder[] = {0,0,0,0};
	colorSea[] = {0.467,0.631,0.851,0.5};
	colorText[] = {0,0,0,1};
	colorTracks[] = {0.84,0.76,0.65,0.15};
	colorTracksFill[] = {0.84,0.76,0.65,0.8};
	deletable = 0;
	fade = 0;
	font = "TahomaB";
	fontGrid = "TahomaB";
	fontInfo = "PuristaMedium";
	fontLabel = "PuristaMedium";
	fontLevel = "TahomaB";
	fontNames = "EtelkaNarrowMediumPro";
	fontUnits = "TahomaB";
	h = "SafeZoneH - 1.5 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
	idc = 51;
	maxSatelliteAlpha = 0.85;
	moveOnEdges = 1;
	ptsPerSquareCLn = 10;
	ptsPerSquareCost = 10;
	ptsPerSquareExp = 10;
	ptsPerSquareFor = 9;
	ptsPerSquareForEdge = 9;
	ptsPerSquareObj = 9;
	ptsPerSquareRoad = 6;
	ptsPerSquareSea = 5;
	ptsPerSquareTxt = 20;
	scaleDefault = 0.16;
	scaleMax = 1;
	scaleMin = 0.001;
	shadow = 0;
	showCountourInterval = 0;
	sizeEx = 0.04;
	sizeExGrid = 0.02;
	sizeExInfo = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
	sizeExLabel = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
	sizeExLevel = 0.02;
	sizeExNames = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8) * 2";
	sizeExUnits = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
	stickX[] = {0.2,["Gamma",1,1.5]};
	stickY[] = {0.2,["Gamma",1,1.5]};
	style = 48;
	text = "#(argb,8,8,3)color(1,1,1,1)";
	type = 101;
	w = "SafeZoneWAbs";
	x = "SafeZoneXAbs";
	y = "SafeZoneY + 1.5 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
	onMouseButtonClick = "";
	onMouseButtonDblClick = "";

	class ActiveMarker {
		color[] = {0.3,0.1,0.9,1};
		size = 50;
	};

	class Legend {
		color[] = {0,0,0,1};
		colorBackground[] = {1,1,1,0.5};
		font = "PuristaMedium";
		h = "3.5 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
		w = "10 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
		x = "SafeZoneX + 					(			((safezoneW / safezoneH) min 1.2) / 40)";
		y = "SafeZoneY + safezoneH - 4.5 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
	};

	class Bunker {
		coefMax = 4;
		coefMin = 0.25;
		color[] = {0,0,0,1};
		icon = "\A3\ui_f\data\map\mapcontrol\bunker_ca.paa";
		importance = "1.5 * 14 * 0.05";
		size = 14;
	};

	class Bush {
		coefMax = 4;
		coefMin = 0.25;
		color[] = {0.45,0.64,0.33,0.4};
		icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";
		importance = "0.2 * 14 * 0.05 * 0.05";
		size = "14/2";
	};

	class BusStop {
		coefMax = 1;
		coefMin = 0.85;
		color[] = {1,1,1,1};
		icon = "\A3\ui_f\data\map\mapcontrol\busstop_CA.paa";
		importance = 1;
		size = 24;
	};

	class Command {
		coefMax = 1;
		coefMin = 1;
		color[] = {1,1,1,1};
		icon = "\A3\ui_f\data\map\mapcontrol\waypoint_ca.paa";
		importance = 1;
		size = 18;
	};
	
	class CustomMark {
		coefMax = 1;
		coefMin = 1;
		color[] = {0,0,0,1};
		icon = "\A3\ui_f\data\map\mapcontrol\custommark_ca.paa";
		importance = 1;
		size = 24;
	};

	class Cross {
		coefMax = 1;
		coefMin = 0.85;
		color[] = {0,0,0,1};
		icon = "\A3\ui_f\data\map\mapcontrol\Cross_CA.paa";
		importance = 1;
		size = 24;
	};
	
	class Shipwreck {
		coefMax = 1;
		coefMin = 0.85;
		color[] = {0,0,0,1};
		icon = "\A3\ui_f\data\map\mapcontrol\Shipwreck_CA.paa";
		importance = 1;
		size = 24;
	};

	class Fortress {
		coefMax = 4;
		coefMin = 0.25;
		color[] = {0,0,0,1};
		icon = "\A3\ui_f\data\map\mapcontrol\bunker_ca.paa";
		importance = "2 * 16 * 0.05";
		size = 16;
	};

	class Fuelstation {
		coefMax = 1;
		coefMin = 0.85;
		color[] = {1,1,1,1};
		icon = "\A3\ui_f\data\map\mapcontrol\fuelstation_CA.paa";
		importance = 1;
		size = 24;
	};

	class Fountain {
		coefMax = 4;
		coefMin = 0.25;
		color[] = {0,0,0,1};
		icon = "\A3\ui_f\data\map\mapcontrol\fountain_ca.paa";
		importance = "1 * 12 * 0.05";
		size = 11;
	};

	class Hospital {
		coefMax = 1;
		coefMin = 0.85;
		color[] = {1,1,1,1};
		icon = "\A3\ui_f\data\map\mapcontrol\hospital_CA.paa";
		importance = 1;
		size = 24;
	};

	class Chapel {
		coefMax = 1;
		coefMin = 0.85;
		color[] = {0,0,0,1};
		icon = "\A3\ui_f\data\map\mapcontrol\Chapel_CA.paa";
		importance = 1;
		size = 24;
	};

	class Church {
		coefMax = 1;
		coefMin = 0.85;
		color[] = {1,1,1,1};
		icon = "\A3\ui_f\data\map\mapcontrol\church_CA.paa";
		importance = 1;
		size = 24;
	};

	class Lighthouse {
		coefMax = 1;
		coefMin = 0.85;
		color[] = {1,1,1,1};
		icon = "\A3\ui_f\data\map\mapcontrol\lighthouse_CA.paa";
		importance = 1;
		size = 24;
	};

	class Quay {
		coefMax = 1;
		coefMin = 0.85;
		color[] = {1,1,1,1};
		icon = "\A3\ui_f\data\map\mapcontrol\quay_CA.paa";
		importance = 1;
		size = 24;
	};

	class Rock {
		coefMax = 4;
		coefMin = 0.25;
		color[] = {0.1,0.1,0.1,0.8};
		icon = "\A3\ui_f\data\map\mapcontrol\rock_ca.paa";
		importance = "0.5 * 12 * 0.05";
		size = 12;
	};

	class Ruin {
		coefMax = 4;
		coefMin = 1;
		color[] = {0,0,0,1};
		icon = "\A3\ui_f\data\map\mapcontrol\ruin_ca.paa";
		importance = "1.2 * 16 * 0.05";
		size = 16;
	};

	class SmallTree {
		coefMax = 4;
		coefMin = 0.25;
		color[] = {0.45,0.64,0.33,0.4};
		icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";
		importance = "0.6 * 12 * 0.05";
		size = 12;
	};

	class Stack {
		coefMax = 4;
		coefMin = 0.9;
		color[] = {0,0,0,1};
		icon = "\A3\ui_f\data\map\mapcontrol\stack_ca.paa";
		importance = "2 * 16 * 0.05";
		size = 20;
	};

	class Tree {
		coefMax = 4;
		coefMin = 0.25;
		color[] = {0.45,0.64,0.33,0.4};
		icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";
		importance = "0.9 * 16 * 0.05";
		size = 12;
	};
	
	class Task {
		coefMax = 1;
		coefMin = 1;
		color[] = {"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])","(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])","(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])","(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8])"};
		colorCanceled[] = {0.7,0.7,0.7,1};
		colorCreated[] = {1,1,1,1};
		colorDone[] = {0.7,1,0.3,1};
		colorFailed[] = {1,0.3,0.2,1};
		icon = "\A3\ui_f\data\map\mapcontrol\taskIcon_CA.paa";
		iconCanceled = "\A3\ui_f\data\map\mapcontrol\taskIconCanceled_CA.paa";
		iconCreated = "\A3\ui_f\data\map\mapcontrol\taskIconCreated_CA.paa";
		iconDone = "\A3\ui_f\data\map\mapcontrol\taskIconDone_CA.paa";
		iconFailed = "\A3\ui_f\data\map\mapcontrol\taskIconFailed_CA.paa";
		importance = 1;
		size = 27;
	};

	class Tourism {
		coefMax = 4;
		coefMin = 0.7;
		color[] = {0,0,0,1};
		icon = "\A3\ui_f\data\map\mapcontrol\tourism_ca.paa";
		importance = "1 * 16 * 0.05";
		size = 16;
	};

	class Transmitter {
		coefMax = 1;
		coefMin = 0.85;
		color[] = {1,1,1,1};
		icon = "\A3\ui_f\data\map\mapcontrol\transmitter_CA.paa";
		importance = 1;
		size = 24;
	};

	class ViewTower {
		coefMax = 4;
		coefMin = 0.5;
		color[] = {0,0,0,1};
		icon = "\A3\ui_f\data\map\mapcontrol\viewtower_ca.paa";
		importance = "2.5 * 16 * 0.05";
		size = 16;
	};

	class Watertower {
		coefMax = 1;
		coefMin = 0.85;
		color[] = {1,1,1,1};
		icon = "\A3\ui_f\data\map\mapcontrol\watertower_CA.paa";
		importance = 1;
		size = 24;
	};
	
	class power {
		coefMax = 1;
		coefMin = 0.85;
		color[] = {1,1,1,1};
		icon = "\A3\ui_f\data\map\mapcontrol\power_CA.paa";
		importance = 1;
		size = 24;
	};
	
	class powersolar {
		coefMax = 1;
		coefMin = 0.85;
		color[] = {1,1,1,1};
		icon = "\A3\ui_f\data\map\mapcontrol\powersolar_CA.paa";
		importance = 1;
		size = 24;
	};
	
	class powerwave {
		coefMax = 1;
		coefMin = 0.85;
		color[] = {1,1,1,1};
		icon = "\A3\ui_f\data\map\mapcontrol\powerwave_CA.paa";
		importance = 1;
		size = 24;
	};
	
	class powerwind {
		coefMax = 1;
		coefMin = 0.85;
		color[] = {1,1,1,1};
		icon = "\A3\ui_f\data\map\mapcontrol\powerwind_CA.paa";
		importance = 1;
		size = 24;
	};

	class Waypoint {
		coefMax = 1;
		coefMin = 1;
		color[] = {0,0,0,1};
		icon = "\A3\ui_f\data\map\mapcontrol\waypoint_ca.paa";
		importance = 1;
		size = 24;
	};

	class WaypointCompleted {
		coefMax = 1;
		coefMin = 1;
		color[] = {0,0,0,1};
		icon = "\A3\ui_f\data\map\mapcontrol\waypointCompleted_ca.paa";
		importance = 1;
		size = 24;
	};
};

class RscHTML {
  idc = -1;
  type = CT_HTML; // defined constant (9)
  style = ST_LEFT; // defined constant (0)
  
  x = 0.1;
  y = 0.1;
  w = 0.6;
  h = 0.5;
  
  filename = "credits.html";
  text="";
  
  colorBackground[] = {1,1,1,0.8};
  colorBold[] = {1, 0, 0, 1};
  colorLink[] = {0, 0, 1, 1};
  colorLinkActive[] = {1, 0, 0, 1};
  colorPicture[] = {1, 1, 1, 1};
  colorPictureBorder[] = {1, 0, 0, 1};
  colorPictureLink[] = {0, 0, 1, 1};
  colorPictureSelected[] = {0, 1, 0, 1};
  colorText[] = {0, 0, 0, 1};
  
  prevPage = "\ca\ui\data\arrow_left_ca.paa";
  nextPage = "\ca\ui\data\arrow_right_ca.paa";
	
	class H1 {
		font = "RobotoCondensed";
		fontBold = "RobotoCondensedBold";
		sizeEx = 0.08;
	};
	
	class H2 {
		font = "RobotoCondensed";
		fontBold = "RobotoCondensedBold";
		sizeEx = 0.07;
	};
	
	class H3 {
		font = "RobotoCondensed";
		fontBold = "RobotoCondensedBold";
		sizeEx = 0.06;
	};
	
	class H4 {
		font = "RobotoCondensed";
		fontBold = "RobotoCondensedBold";
		sizeEx = 0.055;
	};
	
	class H5 {
		font = "RobotoCondensed";
		fontBold = "RobotoCondensedBold";
		sizeEx = 0.05;
	};
	
	class H6 {
		font = "RobotoCondensed";
		fontBold = "RobotoCondensedBold";
		sizeEx = 0.045;
	};
	
	class P {
		font = "RobotoCondensed";
		fontBold = "RobotoCondensedBold";
		sizeEx = 0.04;
	};
};

class voteWeaponsDialog 
{ 
	idd = 100;
	movingEnable = true;
	enableSimulation = true;
	controlsBackground[] = { Container };
	objects[] = { };
	controls[] = {Header, CountDown, ListBoxWeapons, LabelWeapons,
	LabelAttachments, ListBoxAttachmentsMuzzle, ListBoxAttachmentsPointer,
	ListBoxAttachmentsScope, VoteWeaponButton, LabelVoteWeaponProgress,
	ListBoxVoteWeaponProgress};	
	
	class Container : GG_MainContainer {};
	
	class Header : GG_H1 
	{
		text = "Voting : Weapons";
	};
	
	class CountDown : GG_CountDown 
	{
		text = "0";
	};
	
	class ListBoxWeapons : GG_LISTBOX 
	{
		idc = 101;
		x = safezoneX;
		y = (0.1 * safezoneH) + safezoneY;
		w = 0.4 * safezoneW;
		h = 0.4 * safezoneH;
	};
	
	class LabelWeapons : GG_Label
	{
		text = "Weapons";
		x = safezoneX;
		y = (0.05 * safezoneH) + safezoneY;
		w = 0.4 * safezoneW;
		h = 0.05 * safezoneH;
	};
	
	class ListBoxAttachmentsMuzzle : GG_LISTBOX
	{
		idc = 111;
		rowHeight = 0.1;
		sizeEx = 0.08;
		x = (0.4 * safezoneW) + safezoneX;
		y = (0.1 * safezoneH) + safezoneY;
		w = 0.2 * safezoneW;
		h = 0.4 * safezoneH;
	};
	
	class ListBoxAttachmentsPointer : GG_LISTBOX
	{
		idc = 112;
		rowHeight = 0.1;
		sizeEx = 0.08;
		x = (0.6 * safezoneW) + safezoneX;
		y = (0.1 * safezoneH) + safezoneY;
		w = 0.2 * safezoneW;
		h = 0.4 * safezoneH;
	};
	
	class ListBoxAttachmentsScope : GG_LISTBOX
	{
		idc = 113;
		rowHeight = 0.1;
		sizeEx = 0.08;
		x = (0.8 * safezoneW) + safezoneX;
		y = (0.1 * safezoneH) + safezoneY;
		w = 0.2 * safezoneW;
		h = 0.4 * safezoneH;
	};
	
	class LabelAttachments : GG_Label
	{
		text = "Attachments";
		x = (0.4 * safezoneW) + safezoneX;
		y = (0.05 * safezoneH) + safezoneY;
		w = 0.6 * safezoneW;
		h = 0.05 * safezoneH;
	};
	
	class VoteWeaponButton : GG_Button
	{
		idc = 120;
		text = "Add Weapon";
		action = "execVM 'voting\votegunprogresscast.sqf'";
		x = safezoneX;
		y = (0.5 * safezoneH) + safezoneY;
		w = (1 * safezoneW);
		h = (0.05 * safezoneH);
	};
	
	class LabelVoteWeaponProgress : GG_Label
	{
		text = "Voting Progress";
		x = safezoneX;
		y = (0.55 * safezoneH) + safezoneY;
		w = 1 * safezoneW;
		h = 0.05 * safezoneH;
	};
	
	class ListBoxVoteWeaponProgress : GG_LISTBOX 
	{
		idc = 131;
		x = safezoneX;
		y = (0.6 * safezoneH) + safezoneY;
		w = 1 * safezoneW;
		h = 0.4 * safezoneH;
	};	
};

class voteNumRounds 
{ 
	idd = 102;
	movingEnable = true;
	enableSimulation = true;
	controlsBackground[] = { Container };
	objects[] = { };
	controls[] = {Header, CountDown, ListBoxRounds, LabelRounds, Credits };	
	
	class Container : GG_MainContainer {};
	
	class Header : GG_H1 
	{
		text = "Voting : Rounds";
	};
	
	class CountDown : GG_CountDown 
	{
		text = "0";
	};
	
	class ListBoxRounds : GG_LISTBOX
	{
		idc = 101;
		x = safezoneX;
		y = (0.1 * safezoneH) + safezoneY;
		w = 0.3 * safezoneW;
		h = 0.4 * safezoneH;
	};
	
	class LabelRounds : GG_Label
	{
		text = "Rounds";
		x = safezoneX;
		y = (0.05 * safezoneH) + safezoneY;
		w = 0.3 * safezoneW;
		h = 0.05 * safezoneH;
	};
	
	class Credits : RscHTML
	{
		idc = 130;
		text = "Rounds";
		x = safezoneX + (safezoneW * 0.4);
		y = (0.05 * safezoneH) + safezoneY;
		w = 0.5 * safezoneW;
		h = 0.8 * safezoneH;
	};
};

class voteLocation
{ 
	idd = 103;
	movingEnable = true;
	enableSimulation = true;
	controlsBackground[] = { Container };
	objects[] = { };
	controls[] = {Header, CountDown, LabelRounds , EmbededMap};	
	
	class Container : GG_MainContainer {};
	
	class Header : GG_H1 
	{
		text = "Voting : Location";
	};
	
	class CountDown : GG_CountDown 
	{
		text = "0";
	};
	
	class ListBoxLocations : GG_LISTBOX
	{
		idc = 101;
		x = safezoneX;
		y = (0.1 * safezoneH) + safezoneY;
		w = 1 * safezoneW;
		h = 0.2 * safezoneH;
	};
	
	class LabelRounds : GG_Label
	{
		text = "Locations";
		x = safezoneX;
		y = (0.05 * safezoneH) + safezoneY;
		w = 1 * safezoneW;
		h = 0.05 * safezoneH;
	};
	
	class EmbededMap : RscMapControl 
	{
		idc = 110;
		x = safezoneX + (0.1 * safezoneW);
		y = (0.1 * safezoneH) + safezoneY;
		w = 0.8 * safezoneW;
		h = 0.8 * safezoneH;
		class LineMarker
		{
			lineWidthThin = 0.008;
			lineWidthThick = 0.014;
			lineDistanceMin = 3e-005;
			lineLengthMin = 5;
		};
	};
	
};