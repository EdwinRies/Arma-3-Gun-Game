PerPlayerArea = 20 ^ 2;

Spawn_Has_Los_Sim = {
_los = false;
_posTest = (_this select 0) vectorAdd [0,0,1.6]; //1.6 for head height. eye to eye los
_maxDis = _this select 1;
{
	if(_posTest distance getMarkerPos _x < _maxDis) then
	{
		if((!lineIntersects [getMarkerPos _x vectorAdd [0,0,1.6], _posTest]) && (!terrainIntersectASL [getMarkerPos _x vectorAdd [0,0,1.6], _posTest])) exitWith
		{
			_los = true;
			_los;
		};
	};
} foreach simulatedPlayerMarkers;
_los;
};

simulInstance = {
_markerName = _this;
createMarker [_markerName, [0,0,0]];
_markerName setMarkerBrush "Solid";
_markerName setMarkerShape "RECTANGLE";
_markerName setMarkerSize [5, 5];
while{true} do
{
	_playerCount = count(simulatedPlayerMarkers);

	_moddedRadius =  sqrt(_playerCount * PerPlayerArea * pi);
	
	if(_moddedRadius > GUNGAME_wallradius) then 
	{
		_moddedRadius = GUNGAME_wallradius;
	};
	
	_spawning = true;
	_promoteModifier = 0;
	
	_countPlayersInFight = 0;
	_Xtotal = 0;
	_Ytotal = 0;
	_disTotal = 0;
	{
		_posX = getMarkerPos _x;
		_posX set [2, 0];
		if(_posX distance fightPosition < GUNGAME_wallradius) then
		{
			_countPlayersInFight = _countPlayersInFight + 1;
			_Xtotal = _Xtotal + (_posX select 0);
			_Ytotal = _Ytotal + (_posX select 1);
		};
	}foreach simulatedPlayerMarkers;
	
	if(_Xtotal == 0) then {_Xtotal = fightPosition select 0;};
	if(_Ytotal == 0) then {_Ytotal = fightPosition select 1;};
	if(_countPlayersInFight == 0) then {_countPlayersInFight = 1;}; 
	_avgPos = [(_Xtotal / _countPlayersInFight), (_Ytotal / _countPlayersInFight), 0];
	
	_deviation = [0,0,0];
	{
		_posX = getMarkerPos _x;
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
	}foreach simulatedPlayerMarkers;
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
		
	"avgPos" setMarkerPos _avgPos;
	"avgPos" setMarkerDir _avgDeg;
	
	_deviatedDistance = sqrt(_deviation distance _avgPos);
	
	_moddedDistance = _moddedRadius * (1 - (_avgDis / _moddedRadius));
	
	if(_moddedDistance > _moddedRadius) then {
		_moddedDistance = _moddedRadius;
	};
	
	hint str (_avgDis / _moddedRadius);

	
	_calcs = 0;
		
	//Try to spawn the player in the average position but also attempt to spawn in such a way that combat moves closer to deviating players.
		
	_findPosDistanceModifier = 0; //Will try to spawn at suggested position and then in an increasing radius around it. In worst scenario
	_maxLosDistance = 200;
	while {_spawning} do
	{	
	
		_pos = [
		(_avgPos select 0) + ((_moddedDistance + _findPosDistanceModifier - random(_findPosDistanceModifier)) * sin(_avgDeg + _findPosDistanceModifier - random(_findPosDistanceModifier))),
		(_avgPos select 1) + ((_moddedDistance + _findPosDistanceModifier - random(_findPosDistanceModifier)) * cos(_avgDeg + _findPosDistanceModifier - random(_findPosDistanceModifier))),
		0
		];
		"devPos" setMarkerPos _pos;
	
		

	
		if(_findPosDistanceModifier > (GUNGAME_wallradius * 2)) then
		{
			_findPosDistanceModifier = 0;
		};
		_randDeg = random(360);

		while{lineIntersects [(ATLToASL _pos vectorAdd [0,0,0.5]), (ATLToASL _pos vectorAdd [0,0,1])]} do
		{	
			_pos set [2, (_pos select 2) + 2]
		};
		
		if(_pos call Spawn_Is_Flat) then //if there is flatsurface, try to spawn
		{			
			//////////////////////////////////////////////////////////////////////////////////////////////////////
			if((_pos distance fightPosition) < (GUNGAME_wallradius * 0.95)) then 
			{		
				_isLos = [ATLToASL  _pos, _maxLosDistance] call Spawn_Has_Los_Sim;		
				if(!_isLos) then
				{
					_spawning = false;
					_markerName setMarkerPos _pos;
					_markerName setMarkerDir random(360);	
					_markerName setMarkerColor "ColorPink";
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
						_isLos = [ATLToASL _pos, _maxLosDistance] call Spawn_Has_Los_Sim;		
						if(!_isLos) then
						{
							_spawning = false;
							_markerName setMarkerPos _pos;
							_markerName setMarkerDir random(360);	
							_markerName setMarkerColor "ColorPink";
						};	
				};
				_countAttempts = _countAttempts + 1;
				};	
			};			
		};
		
		_findPosDistanceModifier = _findPosDistanceModifier + 5;
		_maxLosDistance = _maxLosDistance - 5;
	};
	
	
	
	
	sleep 1;
	_markerName setMarkerColor "ColorGreen";
	sleep random(20);
	_markerName setMarkerColor "ColorRed";
	sleep 3;
};
};

if(!isNil "simulationArray") then
{
	{
		terminate _x;
	}foreach simulationArray;
}
else
{
	simulationArray = [];
};

createMarker ["avgPos", [0,0,0]];
"avgPos" setMarkerBrush "Solid";
"avgPos" setMarkerShape "RECTANGLE";
"avgPos" setMarkerSize [5, 15];
"avgPos" setMarkerColor "ColorYellow";

createMarker ["devPos", [0,0,0]];
"devPos" setMarkerBrush "Solid";
"devPos" setMarkerShape "RECTANGLE";
"devPos" setMarkerSize [8, 8];
"devPos" setMarkerColor "ColorBlue";

if(!isNil "simulatedPlayerMarkers") then
{
	{	
		deleteMarker _x;
	} foreach simulatedPlayerMarkers;
};

simulatedPlayerMarkers = [];
for[{_i = 0}, {_i < 20}, {_i = _i + 1}] do
{
	_name = str _i;
	deleteMarker _name;
	simulatedPlayerMarkers pushBack _name;
	_handle = _name spawn simulInstance;
	simulationArray pushBack _handle;
	sleep 0.1;
};