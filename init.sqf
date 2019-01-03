enableSaving [false, false];
waituntil {!isNil "bis_fnc_init"};
runningScripts = [];
INACTION = false;

CLEANINGUP = false;

execVM "leaderboard.sqf";

if(!isDedicated) then
{
eachFrameHandles = [];
OnEachFrame {
	{
		call _x;
	} foreach eachFrameHandles;
};


[] spawn {
	"GAME_progress" addPublicVariableEventHandler
	{
		switch(_this select 1) do
		{
		
		case 0: {			
			_h = execVM "voting\votenumrounds.sqf";
			runningScripts pushBack _h;			
		};
		
		case 1: {
			_h = execVM "voting\votefightzone.sqf";
			runningScripts pushBack _h;
		};
		
		case 2: {
			_h = execVM "voting\votegunprogress.sqf";
			runningScripts pushBack _h;
		};	
		
		default {};
		};
	};
	};
};

GGSay = {
systemchat _this;
};

onPlayerConnected "[_id, _name, _uid] execVM ""PlayerConnected.sqf""";
onPlayerDisconnected "[_id, _name, _uid] execVM ""PlayerDisconnected.sqf""";

_h = execVM "dynamicWeapons.sqf";
waitUntil {scriptDone _h};
_h = execVM "townLocations.sqf";
waitUntil {scriptDone _h};

_h = execVM "voterFuncs.sqf";
runningScripts pushBack _h;
waitUntil{scriptDone _h;};

execVM "initiator.sqf";