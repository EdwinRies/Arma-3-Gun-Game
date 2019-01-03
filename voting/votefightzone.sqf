MapMouseClicked = {
_pos = _this;

_closestLoc = ED_locations select 0;
{
	if(((_closestLoc select 2) distance _pos) > ((_x select 2) distance _pos)) then
	{
		_closestLoc = _x;
	};
	str(_x select 2) setMarkerTypeLocal "selector_selectable";
	str(_x select 2) setMarkerColorLocal "ColorBlack";
}foreach ED_locations;



str(_closestLoc select 2) setMarkerTypeLocal "selector_selectedMission";
str(_closestLoc select 2) setMarkerColorLocal "ColorOrange";



if(GAME_progress == 1) then
{
	castVoteZone = [getPlayerUID player, str(_closestLoc select 2)];
	if(!isServer) then
	{
		publicVariableServer "castVoteZone";
	}
	else
	{
		["GUNGAMEVOTES_ZONE", castVoteZone] spawn processIncomingVote;
	};
};

str(_closestLoc select 2) spawn VoteCameraAction;

TRUE;
};

VoteCameraAction = {
{
	if(str(_x select 2) == _this) exitWith
	{
		VOTECAM cameraEffect ["Internal", "Back"];
		VOTECAM camSetTarget [(_x select 2) select 0, (_x select 2) select 1,0];	
		VOTECAM camSetRelPos [-80,80,50];
		VOTECAM camSetFOV .90;
		VOTECAM camSetFocus [50, 0];
		VOTECAM camCommit 0;
		VOTECAM camSetRelPos [80,40,100];
		VOTECAM camCommit 5;
	};
}foreach ED_locations;
};



onMapSingleClick "_pos call MapMouseClicked;";


sleep 0.1;
waitUntil{!dialog};

if(!isNil "voteFightZone") exitWith {};
voteFightZone = true;

VOTE_MARKERS = [];

while {GAME_progress == 1 && isNil "votedfightzone"} do
{
{
	_markerName = str (_x select 2);
	_marker = createMarkerLocal [_markerName, (_x select 2)];
	_markerName setMarkerTypeLocal "selector_selectable";
	_markerName setMarkerPosLocal (_x select 2);
	_markerName setMarkerTextLocal "0";
	_markerName setMarkerColorLocal "ColorBlack";
	VOTE_MARKERS pushback _marker;
}foreach ED_locations;
	
	_dialog = createDialog "voteLocation";	
	disableSerialization;
	_mapctrl = (findDisplay 103) displayCtrl 110;
	_mapctrl ctrlMapAnimAdd [0, 1, ED_mapCenter];
	ctrlMapAnimCommit _mapctrl;
	
	//lbSetCurSel [101, 0];
	waitUntil{GAME_progress != 1};
	if(dialog) then {closeDialog 0};
};

execVM "voting\votegunprogress.sqf";

{
	deleteMarker _x;
}foreach VOTE_MARKERS;

onMapSingleClick "";

if(!isNil "fightPosition") then
{
	(str fightPosition) call VoteCameraAction;
};