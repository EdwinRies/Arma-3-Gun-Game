GUNGAMEVOTES_ROUNDS = [];
GUNGAMEVOTES_WEAPONS = [];
GUNGAMEVOTES_ZONE = [];
GG_voteProgUpdate = nil;

processIncomingVote = {
	_mainArray = call compile (_this select 0);
	_newVote = _this select 1;
	_playerUID = (_this select 1) select 0;
	_playerVote = (_this select 1) select 1;
	_found = -1;
	{
		if(_x select 0 isEqualTo _playerUID) exitWith
		{
			_found = _foreachIndex;
			_mainArray set [_foreachIndex, _playerVote];
			_mainArray;
		};
	}foreach _mainArray;
	if(_found >= 0) then
	{
		[_found, _newVote] call compile format["%1 set [_this select 0, _this select 1]", _this select 0];
	}
	else
	{
		_newVote call compile format["%1 pushBack _this", _this select 0];
	};
	
	if(isNil "SendingVoteProgress" && GAME_progress < 3) then
	{
	SendingVoteProgress = true;	
	call compile format["[%1, ""GG_RoundsVoteProgressUpdate%2""] spawn BIS_fnc_MP;", _this select 0, _this select 0];
	sleep (0.1 + (count(_mainArray) * 0.025));
	SendingVoteProgress = nil;
	};
};

"castVoteRounds" addPublicVariableEventHandler
{
	if(GAME_progress == 0) then
	{
		["GUNGAMEVOTES_ROUNDS", _this select 1] spawn processIncomingVote;
	};
};

"castVoteZone" addPublicVariableEventHandler
{
	if(GAME_progress == 1) then
	{
		["GUNGAMEVOTES_ZONE", _this select 1] spawn processIncomingVote;
	};
};

"castVoteWeapons" addPublicVariableEventHandler
{
	if(GAME_progress == 2) then
	{
		["GUNGAMEVOTES_WEAPONS", _this select 1] spawn processIncomingVote;
	};
};

//////////////////////////////////////////////////////////

publicVariable "GAME_progress";

_h = [vote_time_rounds] spawn GG_SrvrCD;
runningScripts pushBack _h;
waitUntil {scriptDone _h};

_rounds = 10;
_roundvotes = [];
_highest = 0;
{
	_i = 0;
	_found = false;
	while{_i < count(_roundvotes) && !_found} do
	{		
		if(_x select 1 == (_roundvotes select _i) select 0) then
		{
			_roundvotes set [_i,[_x select 1, ((_roundvotes select _i) select 1) + 1]];
			_found = true;
		};
		_i = _i + 1;
	};
	if(!_found) then 
	{
		_roundvotes = _roundvotes + [[_x select 1, 1]];
	};
}foreach GUNGAMEVOTES_ROUNDS;

_most = 0;
{
	if(_x select 1 > _most) then
	{
		_most = _x select 1;
		_rounds = _x select 0;
	};
}foreach _roundvotes;

GUNGAME_ROUNDS = _rounds;
publicVariable "GUNGAME_ROUNDS";
vote_time_guns = GUNGAME_ROUNDS * 1.5;
publicVariable "vote_time_guns";
///////////////////////////////////////////////////////////////////////////////////////

GAME_progress = 1;
publicVariable "GAME_progress";

_h = [vote_time_location] spawn GG_SrvrCD;
runningScripts pushBack _h;
waitUntil {scriptDone _h};

_zone = "";
_highest = 0;
_zoneVotes = [];
{
	_i = 0;
	_found = false;
	while{_i < count(_zoneVotes) && !_found} do
	{		
		if((_x select 1) == (_zoneVotes select _i) select 0) then
		{
			_zoneVotes set [_i,[(_x select 1), ((_zoneVotes select _i) select 1) + 1]];
			_found = true;
		};
		_i = _i + 1;
	};
	if(!_found) then 
	{
		_zoneVotes = _zoneVotes + [[(_x select 1), 1]];
	};
}foreach GUNGAMEVOTES_ZONE;

_zoneWin = ED_locations select (floor(random(count(ED_locations)))) select 1;

for[{_o = 0},{_o < count(_zoneVotes)},{_o = _o + 1}] do
{
	for[{_i = 0},{_i < count(_zoneVotes)},{_i = _i + 1}] do
	{
		if((_zoneVotes select _o select 1) > (_zoneVotes select _i select 1)) then
		{
			_a = _zoneVotes select _o;
			_b = _zoneVotes select _i;
			_zoneVotes set [_o, _b];
			_zoneVotes set [_i, _a];
		};
	};
};

for[{_i = 0},{_i < count(_zoneVotes)},{_i = _i + 1}] do
{
	{
		if(str(_x select 2) == _zoneVotes select _i select 0) exitWith
		{
			fightPosition = _x select 2;
			GUNGAME_wallradius = _x select 3;
		};
	}foreach ED_locations;
	if(!isNil "fightPosition") exitWith{};
};
if(isNil "fightPosition") then 
{
	_rnd = floor(random(count(ED_locations)));
	fightPosition = ED_locations select _rnd select 2;
	GUNGAME_wallradius = ED_locations select _rnd select 3;
};
publicVariable "fightPosition";
publicVariable "GUNGAME_wallradius";

_h = execVM "buildingPlaceMent.sqf";
runningScripts pushBack _h;

_marker = createMarker ["FightZone", fightPosition];
"FightZone" setMarkerBrush "DIAGGRID";
"FightZone" setMarkerColor "ColorRed";
"FightZone" setMarkerShape "ELLIPSE";
"FightZone" setMarkerSize [GUNGAME_wallradius, GUNGAME_wallradius];
"FightZone" setMarkerAlpha 0.5;

GAME_progress = 2;
publicVariable "GAME_progress";

///////////////////////////////////////////////////////////////////////////////////////
getDynamicWeaponInfo = {
	_ar = [];
	{
		if((_x select 0) == _this select 0) exitWith
		{
			_ar = _x;
		};
	}foreach (ED_dynamicWeapons_Primary + ED_dynamicWeapons_HandGun);
	_ar;
};

_h = execVM "dynamicWeapons.sqf";
runningScripts pushBack _h;
waitUntil {scriptDone _h};

_h = [GUNGAME_ROUNDS * 1.5] spawn GG_SrvrCD;
runningScripts pushBack _h;
waitUntil {scriptDone _h};

_gungamevotedweaponarray = [];
_gungameweaponarray = [];
if(count(GUNGAMEVOTES_WEAPONS) > 0) then {

////

{
	_i = 0;
	_found = false;
	while{_i < count(_gungamevotedweaponarray) && !_found} do
	{	
		if((_x select 1) isEqualTo ((_gungamevotedweaponarray select _i) select 0)) then
		{
			_gungamevotedweaponarray set [_i,[(_x select 1), ((_gungamevotedweaponarray select _i) select 1) + 1]];
			_found = true;
		};
		_i = _i + 1;
	};
	if(!_found) then 
	{
		_gungamevotedweaponarray = _gungamevotedweaponarray + [[(_x select 1), 1]];
	};	
}foreach GUNGAMEVOTES_WEAPONS;
//Sort array from most voted to least voted
for[{_o = 0},{_o < count(_gungamevotedweaponarray)},{_o = _o + 1}] do
{
	for[{_i = 0},{_i < count(_gungamevotedweaponarray)},{_i = _i + 1}] do
	{
		if((_gungamevotedweaponarray select _o select 1) > (_gungamevotedweaponarray select _i select 1)) then
		{
			_a = _gungamevotedweaponarray select _o;
			_b = _gungamevotedweaponarray select _i;
			_gungamevotedweaponarray set [_o, _b];
			_gungamevotedweaponarray set [_i, _a];
		};
	};
};

////

for[{_i = 0}, {count(_gungameweaponarray) < GUNGAME_ROUNDS}, {_i = _i + 1}] do
{
	if(_i < count(_gungamevotedweaponarray)) then
	{
		if(count(((_gungamevotedweaponarray select _i) select 0) call getDynamicWeaponInfo) > 0) then
		{		
			_tmpVote = ((_gungamevotedweaponarray select _i) select 0);
			_class = (_tmpVote call getDynamicWeaponInfo) select 0;
			_attachments = (_tmpVote select 1);
			_magazine = ((_tmpVote call getDynamicWeaponInfo) select 3) select 0;
			_gungameweaponarray = _gungameweaponarray + [[_class, _attachments, _magazine]];
		};
	}
	else
	{	
		_wpnClass = (ED_dynamicWeapons_Primary + ED_dynamicWeapons_HandGun) 
			select floor(random(count(ED_dynamicWeapons_Primary + ED_dynamicWeapons_HandGun))) select 0;
		_wpnInfo = ([_wpnClass] call getDynamicWeaponInfo);
		_magazine = (_wpnInfo select 3) select 0;
		_atcmnts = (_wpnInfo select 5);
		_muzzles = [""];
		_pointers = [""];
		_scopes = [""];
		if(count(_atcmnts select 0) > 0) then {_muzzles = _muzzles + (_atcmnts select 0)};
		if(count(_atcmnts select 1) > 0) then {_pointers = _pointers + (_atcmnts select 1)};
		if(count(_atcmnts select 2) > 0) then {_scopes = _scopes + (_atcmnts select 2)};
		_muzzle = _muzzles select floor(random(count(_muzzles)));
		_pointer = _pointers select floor(random(count(_pointers)));
		_scope = _scopes select floor(random(count(_scopes)));	
		
		_attachments = [_muzzle, _pointer, _scope];
		_gungameweaponarray = _gungameweaponarray + [[_wpnClass, _attachments, _magazine]];
	};
};
////
} 
else
{
	for "_i" from 0 to GUNGAME_ROUNDS do {
		_wpnClass = (ED_dynamicWeapons_Primary + ED_dynamicWeapons_HandGun) 
			select floor(random(count(ED_dynamicWeapons_Primary + ED_dynamicWeapons_HandGun))) select 0;
		_wpnInfo = ([_wpnClass] call getDynamicWeaponInfo);
		_magazine = (_wpnInfo select 3) select 0;
		_atcmnts = (_wpnInfo select 5);
	
		_muzzles = [""];
		_pointers = [""];
		_scopes = [""];
		if(count(_atcmnts select 0) > 0) then {_muzzles = _muzzles + (_atcmnts select 0)};
		if(count(_atcmnts select 1) > 0) then {_pointers = _pointers + (_atcmnts select 1)};
		if(count(_atcmnts select 2) > 0) then {_scopes = _scopes + (_atcmnts select 2)};
		_muzzle = _muzzles select floor(random(count(_muzzles)));
		_pointer = _pointers select floor(random(count(_pointers)));
		_scope = _scopes select floor(random(count(_scopes)));	
		
		_attachments = [_muzzle, _pointer, _scope];
		_gungameweaponarray = _gungameweaponarray + [[_wpnClass, _attachments, _magazine]];
	};
};
GUNGAME_WEAPONARRAY = _gungameweaponarray;
publicVariable "GUNGAME_WEAPONARRAY";

GAME_progress = 3;
publicVariable "GAME_progress";
//////////////////////////////////////////////////////////////////////////////////////////
