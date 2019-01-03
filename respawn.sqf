Spawn_Has_Los = {
_los = false;
_posTest = (_this select 0) vectorAdd [0,0,1.6]; //1.6 for head height. eye to eye los
_maxDis = _this select 1;
{
	if(alive _x) then
	{
		if(_posTest distance _x < _maxDis) then
		{
			if((!lineIntersects [eyePos _x, _posTest, _x]) && (!terrainIntersectASL [eyePos _x, _posTest])) exitWith
			{
				_los = true;
				_los;
			};
		};
	};
} foreach allPlayers;
_los;
};

Spawn_Is_Flat = {
	if(count(_this isFlatEmpty [0.5, 0, 50, 5, 0, false, objNull]) > 0) then
	{
		true;
	}
	else
	{
		false;
	};
};

"respawnResponse" addPublicVariableEventHandler 
{
	maySpawn = true;
};
killStreakCounter = 0;
while{true} do
{
	waitUntil{alive player};
	player enableSimulation false;
	player addeventhandler ["HandleDamage", {0;}];
	call killStreakStopFunc;
	killStreakCounter = 0;
	
	_moddedRadius =  sqrt(count(allPlayers) * (20 ^ 2) * pi);
	if(_moddedRadius > GUNGAME_wallradius) then 
	{
		_moddedRadius = GUNGAME_wallradius;
	};
	
	call spawnGuns;
	player addRating -100000;
	
	player removeAllEventHandlers "killed";
	maySpawn = false;
	if(!isServer) then
	{
		requestSpawn = player;
		publicVariableServer "requestSpawn";
	}
	else
	{
		respawnQueue pushBack player;
	};
	waitUntil{maySpawn};
	player addEventHandler["killed", {(_this select 1) call killFunc}];
	
	_spawning = true;	
	_countPlayersInFight = 0;
	_Xtotal = 0;
	_Ytotal = 0;

	{
		if(alive _x) then 
		{
			_posX = getPos _x;
			_posX set [2, 0];
			if(_posX distance fightPosition < GUNGAME_wallradius) then
			{
				_countPlayersInFight = _countPlayersInFight + 1;
				_Xtotal = _Xtotal + (_posX select 0);
				_Ytotal = _Ytotal + (_posX select 1);
			};
		};
	}foreach allPlayers;
	
	if(_Xtotal == 0) then {_Xtotal = fightPosition select 0;};
	if(_Ytotal == 0) then {_Ytotal = fightPosition select 1;};
	if(_countPlayersInFight == 0) then {_countPlayersInFight = 1;}; 
	_avgPos = [(_Xtotal / _countPlayersInFight), (_Ytotal / _countPlayersInFight), 0];
	
	_deviation = [0,0,0];
	_disTotal = 0;
	{
		if(isPlayer _x) then {
		if(alive _x) then {
		_posX = getPos _x;
		_posX set [2, 0];
		if(_posX distance fightPosition < GUNGAME_wallradius) then
		{
			_disPlayer = _posX distance _avgPos;
			if(_disPlayer > _moddedRadius) then {_disPlayer = _moddedRadius;};
			_disTotal = _disTotal + _disPlayer;
			_deviation = _deviation vectorAdd [
			((_avgPos select 0) - (_posX select 0)) ^ 3,
			((_avgPos select 1) - (_posX select 1)) ^ 3,
			0
			];
		};
		};
		};
	}foreach playableUnits;
	_avgDeg = 0;
	_avgDis = _disTotal / _countPlayersInFight;

	
	if(_countPlayersInFight >= 3) then
	{
		_avgDeg = ((_deviation select 0) - (_avgPos select 0)) atan2 ((_deviation select 1) - (_avgPos select 1)) + 180;
	}
	else
	{
		_avgDeg = random(360);
	};
	
	_moddedDistance = _moddedRadius * (1 - (_avgDis / _moddedRadius));
	
	if(_moddedDistance > _moddedRadius) then {
		_moddedDistance = _moddedRadius;
	};
	
	_spawnAround = _avgPos;
	
	//Try to spawn the player in the average position but also attempt to spawn in such a way that combat moves closer to deviating players.
	_suggested_x = (_spawnAround select 0) + (_moddedDistance * sin(_avgDeg + 60 - random (120)));
	_suggested_y = (_spawnAround select 1) + (_moddedDistance * cos(_avgDeg + 60 - random (120)));
	
	if([_suggested_x, _suggested_y, 0] distance fightPosition > GUNGAME_wallradius) then
	{
		_suggested_x = fightPosition select 0;
		_suggested_y = fightPosition select 1;
	};
	
	_findPosDistanceModifier = 0; //Will try to spawn at suggested position and then in an increasing radius around it. In worst scenario
	_maxLosDistance = 200;
	while {_spawning} do
	{	
		if(_findPosDistanceModifier > (GUNGAME_wallradius * 2)) then
		{
			_findPosDistanceModifier = 0;
		};
		_randDeg = random(360);
		_pos = [_suggested_x + random(_findPosDistanceModifier * sin(_randDeg)), _suggested_y + random(_findPosDistanceModifier * cos((_randDeg))), 0];
		
		_attemptCorrection = 0;
		while{(_pos distance fightPosition > GUNGAME_wallradius * 0.95) && _attemptCorrection < 10} do //Incase the direction is toward out of bounds
		{
			_randDeg = _randDeg + 50 + random(10);
			_pos = [_suggested_x + random(_findPosDistanceModifier * sin(_randDeg)), _suggested_y + random(_findPosDistanceModifier * cos((_randDeg))), 0];
			_attemptCorrection =  _attemptCorrection + 1;
		};	
		
		if(_pos call Spawn_Is_Flat) then //if there is flatsurface, try to spawn
		{		
			while{lineIntersects [(ATLToASL _pos vectorAdd [0,0,0.5]), (ATLToASL _pos vectorAdd [0,0,1])]} do
			{	
				_pos set [2, (_pos select 2) + 2]
			};		
			//////////////////////////////////////////////////////////////////////////////////////////////////////
			if((_pos distance fightPosition) < (GUNGAME_wallradius * 0.95)) then 
			{		
				_isLos = [ATLToASL  _pos, _maxLosDistance] call Spawn_Has_Los;		
				if(!_isLos) then
				{
					_spawning = false;
					player setPosATL _pos;
					player setDir random(360);
					player enableFatigue false;	
				};	
			};
		}
		else //if there is no flatsurface, it might be a building
		{
			//Buildings//////////////////////////////////////////////////////////////////////////////////////////
			_buildings = nearestObjects[_pos, ["House"], 30];
			_buildingsPositions = [];		
			{
				_building = _x;
				_endloop = false;
				_poscount = 0;
				while {!_endloop} do 
				{
					if(((_building buildingPos _poscount) select 0) != 0 && ((_building buildingPos _poscount) select 1) != 0) then {
						_tmp = _building buildingPos _poscount;
						_tmp set [2, 0];
						if(_tmp distance _pos < 30) then
						{
							if(lineIntersects [(ATLToASL _tmp vectorAdd [0,0,0.5]), (ATLToASL _tmp vectorAdd [0,0,1])]) then
							{
								_buildingsPositions = _buildingsPositions + [_building buildingPos _poscount];
							};
						};
						_poscount = _poscount + 1;
					} else 
					{
						_endloop = true;
					};
				};			
			}foreach _buildings;
			_countAttempts = 0;
			if(count(_buildingsPositions) > 0) then
			{
				while{_spawning && _countAttempts < 10} do
				{			
					if(count(_buildingsPositions) > 0) then
					{
						_pos = _buildingsPositions select (floor(random(count(_buildingsPositions))));
					};				
					if((_pos distance fightPosition) < (GUNGAME_wallradius * 0.95)) then 
					{		
						_isLos = [ATLToASL _pos, _maxLosDistance] call Spawn_Has_Los;		
						if(!_isLos) then
						{
							_spawning = false;
							player setPos _pos;
							player setDir random(360);
							player enableFatigue false;	
						};	
				};
				_countAttempts = _countAttempts + 1;
				};	
			};			
		};
		
		_findPosDistanceModifier = _findPosDistanceModifier + 5;
		_maxLosDistance = _maxLosDistance - 5;
	};
		
	player removeAllEventHandlers "HandleDamage";
	player addeventhandler ["HandleDamage", {if(player == _this select 3) then {((_this select 2) / 10);};}];
		
	titleText ["", "BLACK IN", 0.1];
	player enableSimulation true;
	RESPAWNING = false;
	INACTION = true;
	if(GG_LeaderBoardShowing) then {[] spawn GG_Leaderboard_Toggle;};
	waitUntil{!alive player};
	[] spawn {
		sleep 1;
		{
			deleteVehicle _x;
		}foreach nearestObjects [player, ["WeaponHolderSimulated", "WeaponHolder"], 30];
	};
	
	INACTION = false;
	RESPAWNING = true;
	hideBody player;
	GUNGAME_WASDEAD = true;
	if(!GG_LeaderBoardShowing) then {[] spawn GG_Leaderboard_Toggle;};
};