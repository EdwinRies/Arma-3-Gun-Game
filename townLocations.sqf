//ED_locations_NameLocal etc. (All types)
//name, position, radius, type

ED_mapCenter = getArray(configFile >> "cfgWorlds" >> worldName >> "centerPosition");
ED_mapCenter set [2, 0];
ED_mapSize = getNumber(configfile >> "CfgWorlds" >> worldName >> "mapSize") / 2;
ED_locations = [];
/*-----------------------------------------------------
--Comment this out if you don't want custom locations--
-----------------------------------------------------*/
if(!isNil "CustomTowns") then 
{
ED_locations = CustomTowns;
};
//-----------------------------------------------------



/*------------------------------------------------------------
--Comment this out if you don't want the default cities etc.--
------------------------------------------------------------*/
_cfg = configfile >> "CfgWorlds" >> worldName >> "Names";
for[{_i = 0}, {_i < count(_cfg)}, {_i = _i + 1}] do
{
	_loc = _cfg select _i;
	_type = getText(_loc >> "type");
	_name = getText(_loc >> "name");
	if(_name == "") then {_name = "unnamed"};
	_pos = getArray(_loc >> "position");
	_pos set [2, 0];
	_radius = if(getNumber(_loc >> "radiusA") >= getNumber(_loc >> "radiusB")) then {getNumber(_loc >> "radiusA")} else {getNumber(_loc >> "radiusB")};
	if(_name != "unnamed" && _type != "NameMarine")
	then {
	ED_locations = ED_locations + [[_type, _name, _pos, _radius]];
	};
};
//------------------------------------------------------------

//Sorting
[] spawn {
for[{_i = 0}, {_i < count(ED_locations)}, {_i = _i + 1}] do
{
	for[{_j = 0}, {_j < count(ED_locations)}, {_j = _j + 1}] do
	{
		_str1 = toArray(toLower((ED_locations select _i) select 1));
		_str2 = toArray(toLower((ED_locations select _j) select 1));
		for[{_k = 0}, {_k < count(_str1) && _k < count(_str2)}, {_k = _k + 1}] do
        {		
			if ((_str1 select _k) < (_str2 select _k)) exitWith
			{
				_tmpAr = ED_locations select _i;
				_tmpAr2 = ED_locations select _j;
				ED_locations set [_j, _tmpAr];
				ED_locations set [_i, _tmpAr2];	
			};
			if ((_str1 select _k) > (_str2 select _k)) exitWith {};
        };
	};
};
};
