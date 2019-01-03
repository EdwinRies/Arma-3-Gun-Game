_urbanEnough = false;
_buildingClasses = [];
_config = configFile >> "CfgVehicles";
for[{_i = 0}, {_i < count(_config)}, {_i = _i + 1}] do
{
	_tmp = _config select _i;
	if(isClass _tmp) then
	{
		_simType = getText(_tmp >> "simulation");	
		if(_simType == "house") then
		{
			_scope = getNumber(_tmp >> "scope");
			if(_scope == 1) then
			{
				if(count(_tmp >> "UserActions") > 0) then
				{
				_class = configName(_tmp);
				_buildingClasses = _buildingClasses + [_class];
				};
			};
		};
	};
};
_buildings = count(nearestObjects[fightPosition, ["ALL"], GUNGAME_wallradius]);

_allStuff = count(nearestObjects[fightPosition, [], GUNGAME_wallradius * 0.2]);

_buildingsPlacedAttempts = 0;

if((_allStuff / (pi * (0.2 * GUNGAME_wallradius ^ 2))) > (1/(40^2))) then
{
_urbanEnough = true;
}
else
{
if(count(_buildingClasses) == 0) then
{
	_urbanEnough = true;
}
else
{
if((_buildings / (pi * (GUNGAME_wallradius ^ 2))) > (1/(80^2))) exitWith
	{
		_urbanEnough = true;
	};
	if(!_urbanEnough) then
	{
_fromCenterMult = 0;
_class = _buildingClasses select floor(random(count(_buildingClasses)));
_building = _class createVehicle [0,0,0];
_boundingBox = boundingBox _building;
_length = abs(((_boundingBox select 0) select 0) - ((_boundingBox select 1) select 0));
_width = abs(((_boundingBox select 0) select 1) - ((_boundingBox select 1) select 1));
_safeRad = _length * 0.6;
if(_width > _length) then
{
	_safeRad = _width  * 0.6;
};
while{!_urbanEnough || _buildingsPlacedAttempts > 100} do
{
	_buildingsPlacedAttempts = _buildingsPlacedAttempts + 1;
	if(_fromCenterMult < 100) then
	{
	_fromCenterMult = _fromCenterMult + 0.5;
	};
	if((_buildings / (pi * (GUNGAME_wallradius ^ 2))) > (1/(80^2))) exitWith
	{
		_urbanEnough = true;
	};
	
	_x = (fightPosition select 0) + ((_fromCenterMult / 100) * GUNGAME_wallradius * sin(random(360)));
	_y = (fightPosition select 1) + ((_fromCenterMult / 100) * GUNGAME_wallradius * cos(random(360)));
	_pos = [_x, _y, 0];
	
	_newPos = [_pos, 0, 50, _safeRad, 0, 10, 0] call BIS_fnc_findSafePos;	
	_newPos set [2, 0];
	
	if(_newPos select 0 != ED_mapCenter select 0 && _newPos select 1 != ED_mapCenter select 1) then 
	{
		if(_newPos distance fightPosition < GUNGAME_wallradius) then
		{
			_newPos set [2, 0.01];
			_building setPos _newPos;
			_dir = random(360);
			_building setDir _dir;
			_building setVectorUp [0,0,1];
			_buildings = _buildings + 1;
			_markerName = str(random(1000000));
			createMarker [_markerName, [0,0,0]];
			_markerName setMarkerBrush "Solid";
			_markerName setMarkerShape "RECTANGLE";
			_markerName setMarkerSize [_length / 2, _width / 2];
			_markerName setMarkerDir _dir;
			_markerName setMarkerPos _newPos;
			_markerName setMarkerColor "ColorGrey";
			
			
			_class = _buildingClasses select floor(random(count(_buildingClasses)));		
			_building = _class createVehicle [0,0,0];	
			_boundingBox = boundingBox _building;
			_length = abs(((_boundingBox select 0) select 0) - ((_boundingBox select 1) select 0));
			_width = abs(((_boundingBox select 0) select 1) - ((_boundingBox select 1) select 1));
			
		
		_safeRad = _length  * 0.6;
		if(_width > _length) then
		{
			_safeRad = _width  * 0.6;
		};			
		};		
	};
};
};
};
};