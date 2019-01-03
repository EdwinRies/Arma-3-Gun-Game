player switchMove "";

vote_time_rounds = 10;

vote_time_location = 20;

removeAllWeapons player;

giveScore = "";

VOTECAM = "camera" camCreate ED_mapCenter;
showCinemaBorder false;
VOTECAM cameraEffect ["Internal", "Back"];
VOTECAM camSetTarget (ED_locations select (floor(random(count(ED_locations)))) select 2);
VOTECAM camSetRelPos [0,0,200];
VOTECAM camSetFOV .90;
VOTECAM camSetFocus [50, 0];
VOTECAM camCommit 0;

if(isServer) then {
	GAME_progress = 0;	
	_h = execVM "wallplacement.sqf";	
	runningScripts pushBack _h;
	_h = execVM "voting\server.sqf";	
	runningScripts pushBack _h;
	_h = execVM "scoreHandleServer.sqf";
	runningScripts pushBack _h;
};

if(!isDedicated) then
{
	_h = execVM "voting\votenumrounds.sqf";
	runningScripts pushBack _h;
	_h = execVM "killStreaks.sqf";
	runningScripts pushBack _h;
};

_h = [] spawn {
sleep 1;
while {GAME_progress < 2} do
{
showCinemaBorder false;
VOTECAM cameraEffect ["Internal", "Back"];
VOTECAM camSetTarget (ED_locations select (floor(random(count(ED_locations)))) select 2);
VOTECAM camCommit 0;
VOTECAM camSetRelPos [0,0,200];
VOTECAM camSetFOV .90;
VOTECAM camSetFocus [50, 0];
VOTECAM camCommit 120;
sleep 60;
};
};
runningScripts pushBack _h;

"winner" addPublicVariableEventHandler
{
	(_this select 1) spawn {
	removeAllWeapons player;
	hint format["%1 won the game!", _this];
	GAME_progress = 4;
	execVM "cleanupRound.sqf"; 
	GAME_progress = 0;
	};
};

if(!isServer) then {
	"giveScoreClient" addPublicVariableEventHandler
	{
			(_this select 1) call gunGameFunc;
	};
};

if(!isDedicated) then
{
	player enableSimulation false;
	
	waitUntil{!isNil "GUNGAME_ROUNDS"};
	systemchat format["Total rounds: %1", GUNGAME_ROUNDS];
	waitUntil{!isNil "GUNGAME_WEAPONARRAY"};
	waitUntil{!isNil "fightPosition"};
	
	//execVM "spawnpoints_precache.sqf"; //WIP

	player enableSimulation true;	
	
	GUNGAME_WASDEAD = false;
	_h = execVM "gungamefuncs.sqf";
	runningScripts pushBack _h;
	waitUntil{scriptDone _h};
	_h = execVM "respawn.sqf";
	runningScripts pushBack _h;
	_h = execVM "regen.sqf";	
	runningScripts pushBack _h;
	
	
	fightZoneBoundryFunc = {
		if(INACTION) then
		{
			_pos = getPos player;
			_pos set [2, 0];
			if((_pos) distance fightPosition > (GUNGAME_wallradius + 10)) then{player setDamage 1};
		};
	};

	eachFrameHandles pushBack fightZoneBoundryFunc;
};





VOTECAM cameraEffect ["TERMINATE","BACK"];
camDestroy VOTECAM;