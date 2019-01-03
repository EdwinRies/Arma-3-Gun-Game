//Author: Ed!
//Credits: http://blog.ivank.net/fortunes-algorithm-and-implementation.html
findSpawn = {					
	params ['_sites', '_center', '_radius'];	
	
	if(count(_center) < 2) exitWith {false;};
	
	if(count(_sites) < 2) exitWith {_center;};
	
	_places = []; //[_point, _cell aka polygon, pe(parabola event)]
	_cells = [];
	_edges = [];
	
	_queue = [];
	
	_fp = nil;
	_root = nil;
	_lY = 0;
	_lastY = (_center select __y) + _radius;
	_num = 0;
	
	__x = 0;	
	__y = 1;
	
	__point = 0;
	__cell = 1;
	__pe = 2;
	
	{
		_places pushBack [_x, [], true]
	} foreach _sites
	
	if(_radius <= 0) exitWith {_center;};	
	
	for [{_i = 0}, {_i < count(_places)}, {_i = _i + 1}] do
	{
		_queue pushBack [_places select _i]; //indexes for places
	};
	
	
	
	while(count(_queue) > 0) do
	{
		_queue = [_queue, [], {_x select __point select __y}, "ASCEND"] call BIS_fnc_sortBy
		_e = _queue select 0;
		_queue deleteAt 0;
		_lY = _e select __point select __y;
		if(_e select __pe) then
		{
			if(isNil "_root") then {_root = []}
		};
	};
	
	
};