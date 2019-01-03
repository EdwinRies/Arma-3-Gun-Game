if(CLEANINGUP) exitWith{};

CLEANINGUP = true;

{
	terminate _x;
} foreach runningScripts;
runningScripts = [];

if(isServer) then {
	{
		deleteVehicle _x;
	}foreach allMissionObjects "ALL";
	
	playerScoreArray = nil;
	playerScoreArrayIndex = nil;
	playerScoreNamesArray = nil;
	
	{			
		if(isPlayer _x)	then {		
			_x addScore (-(score _x));
		};
	} foreach playableUnits;
};

{
	if(markerText _x != "RESPAWN") then
	{
		deleteMarker _x;
	}
} forEach allMapMarkers;

GUNGAME_WEAPONARRAY = nil;
fightPosition = nil;
GUNGAME_wallradius = nil;
voteNumRounds = nil;
voteFightZone = nil;
voteGunProgress = nil;
INACTION = false;
GUNGAME_SCORE = nil;
GUNGAME_ROUNDS = nil;

if(!isDedicated) then 
{
	if(GG_LeaderBoardShowing) then
	{
		[] spawn GG_Leaderboard_Toggle;
	};
};

if(isServer) then
{
	["Map Cleaned.", "GGSay"] spawn BIS_fnc_MP;
	["Voting will start in 5 seconds...", "GGSay"] spawn BIS_fnc_MP;
};
sleep 5;
execVM "initiator.sqf";

CLEANINGUP = false;